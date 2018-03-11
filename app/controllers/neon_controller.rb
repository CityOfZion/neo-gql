class NeonController < ApplicationController
  NEO_ID = '0xc56f33fc6ecfcd0c225c4ab356fee59390af8560be0e930faebe74a6daff7c9b'
  GAS_ID = '0x602c79718b16e442de58778e148d0b1084e3b2dffd5de6b7b16cee7969282de7'

  def network_nodes
    json nodes: Node.all.map { |node| node.slice(:block_height, :status, :time, :url) }
  end

  def network_best_node
    json node: Node.best.url
  end

  def block_sys_fee
    json fee: Transaction.joins(:block).where('sys_fee > 0 AND blocks.index <= ?', 0).sum(:sys_fee).to_i
  end

  def block_height
    json block_height: Block.height
  end

  def address_balance
    account = Account.find_by_address(params[:address])
    balances = Asset.all.reduce({}) do |memo, asset|
      memo[asset.common_name] = {
        balance: Balance.where(account: account, asset: asset).first&.value || 0,
        unspent: Output.where(account: account).unclaimed(asset).map { |o|
          d = o.slice(:index, :txid, :value)
          d['txid'] = d['txid'].split('0x').last
          d
        }
      }
      memo
    end

    json balances.merge(address: params[:address])
  end

  def address_claims
    address = params[:address]
    transactions = Hash[Transaction.where('vout @> :q OR vin_verbose @> :q', { q: [{ address: address }].to_json }).collect { |tx| [strip_prefix(tx.txid), tx] }]
    info_sent = transactions.values.map { |tx| info_sent_transaction address, tx }
    sent_neo = collect_txids(info_sent)[:NEO]
    info_received = transactions.values.map { |tx| info_received_transaction address, tx }
    received_neo = collect_txids(info_received)[:NEO]
    unspent_neo = received_neo.select { |k, v| !sent_neo[k] }
    past_claims = get_past_claims(address)
    claimed_neo = get_claimed_txids(past_claims)
    valid_claims = sent_neo.select { |k, v| !claimed_neo[k] }
    valid_claims = filter_claimed_for_other_address(valid_claims)
    block_diffs = compute_claims(valid_claims, transactions)
    unspent_diffs = compute_claims(unspent_neo.values, transactions, Block.height)

    json total_claim: calculate_bonus(block_diffs),
         total_unspent_claim: calculate_bonus(unspent_diffs),
         address: address,
         claims: block_diffs
  end

  def address_history
    address = params[:address]
    transactions = Transaction.
      where('vout @> :q OR vin_verbose @> :q', { q: [{ address: address }].to_json }).
      joins(:block).
      order('blocks.index DESC').
      limit(20)
    history = transactions.map { |tx|
      neo_in, neo_out = 0, 0
      gas_in, gas_out = 0.0, 0.0
      neo_sent, gas_sent = false, false
      tx['vin_verbose'].each do |vin|
        if vin['address'] == address
          neo_out += vin['value'].to_i if vin['asset'] == NEO_ID
          gas_out += vin['value'].to_f if vin['asset'] == GAS_ID
        end
      end
      tx['vout'].each do |vout|
        if vout['address'] == address
          neo_in += vout['value'].to_i if vout['asset'] == NEO_ID
          gas_in += vout['value'].to_f if vout['asset'] == GAS_ID
        end
      end
      neo_total = neo_in - neo_out
      gas_total = gas_in - gas_out

      {
        txid: strip_prefix(tx.txid),
        block_index: tx.block.index,
        NEO: neo_total,
        GAS: gas_total,
        neo_sent: !neo_total.zero?,
        gas_sent: !gas_total.zero?
      }
    }
    json name: "transaction_history", address: address, history: history
  end

  # noop
  def log
    json success: "True"
  end

  def version
    json version: "0.0.7"
  end

  private

  def json(data)
    render json: data.merge({ net: network_name })
  end

  def network_name
    case ENV.fetch('NEO_NET') { 'test' }
    when 'main' then 'MainNet'
    when 'test' then 'TestNet'
    else 'PrivNet'
    end
  end

  def strip_prefix(hex)
    hex.split('0x').last
  end

  def info_received_transaction(address, tx)
    out = { NEO: [], GAS: [] }
    return out if tx.vout.empty?
    tx.vout.each do |vout|
      if vout['address'] == address
        out[:NEO] << { value: vout['value'].to_i, index: vout['n'], txid: strip_prefix(tx.txid) } if vout['asset'] == NEO_ID
        out[:GAS] << { value: vout['value'].to_f, index: vout['n'], txid: strip_prefix(tx.txid) } if vout['asset'] == GAS_ID
      end
    end
    out
  end

  def info_sent_transaction(address, tx)
    out = { NEO: [], GAS: [] }
    return out if tx.vin_verbose.empty?
    tx.vin_verbose.each do |vin|
      if vin['address'] == address
        out[:NEO] << { value: vin['value'].to_i, index: vin['n'], txid: strip_prefix(vin['txid']), sending_id: strip_prefix(tx.txid) } if vin['asset'] == NEO_ID
        out[:GAS] << { value: vin['value'].to_f, index: vin['n'], txid: strip_prefix(vin['txid']), sending_id: strip_prefix(tx.txid) } if vin['asset'] == GAS_ID
      end
    end
    out
  end

  def collect_txids(txs)
    store = { NEO: {}, GAS: {} }
    txs.each do |tx|
      [:NEO, :GAS].each do |k|
        tx[k].each do |tx_|
          store[k][[tx_[:txid], tx_[:index]]] = tx_
        end
      end
    end
    store
  end

  def get_past_claims(address)
    Transaction.where("vout @> ? AND tx_type = 'ClaimTransaction'", [{ address: address }].to_json)
  end

  def get_claimed_txids(txs)
    claimed_ids = {}
    txs.each do |tx|
      tx.data['claims'].each do |claim|
        claimed_ids[[strip_prefix(claim['txid']), claim['vout']]] = tx
      end
    end
    claimed_ids
  end

  def filter_claimed_for_other_address(claims)
    out_claims = []
    claims.keys.each do |k|
        tx = Transaction.where("tx_type = 'ClaimTransaction' AND data->'claims' @> ?", [{ txid: k[0], vout: k[1] }].to_json).first
        out_claims << claims[k] unless tx
    end
    out_claims
  end

  def compute_claims(claims, transactions, end_block = false)
    block_diffs = []
    claims.each do |tx|
      # raise tx.to_s
      txid = tx[:txid]
      obj = { txid: txid }
      obj[:start] = transactions[txid].block.index
      obj[:value] = tx[:value]
      obj[:index] = tx[:index]
      unless end_block
          obj[:end] = transactions[tx[:sending_id]].block.index
      else
          obj[:end] = end_block
      end
      obj[:sysfee] = compute_sys_fee_diff(obj[:start], obj[:end])
      obj[:claim] = calculate_bonus([obj])
      block_diffs << obj
    end
    block_diffs
  end

  def compute_sys_fee_diff(a, b)
    Transaction.
      where("sys_fee > 0 AND blocks.index >= ? AND blocks.index <= ?", a, b).
      joins(:block).
      sum(:sys_fee).
      to_i
  end

  GENERATION_AMOUNT = [8, 7, 6, 5, 4, 3, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1]
  GENERATION_LENGTH = 22
  DECREMENT_INTERVAL = 2000000

  def calculate_bonus(claims)
    amount_claimed = 0
    claims.each do |claim|
      start_height = claim[:start]
      end_height = claim[:end]
      amount = 0
      ustart = start_height / DECREMENT_INTERVAL
      if ustart < GENERATION_LENGTH
        istart = start_height % DECREMENT_INTERVAL
        uend = end_height / DECREMENT_INTERVAL
        iend = end_height % DECREMENT_INTERVAL
        if uend >= GENERATION_LENGTH
          uend = GENERATION_LENGTH
          iend = 0
        end
        if iend == 0
          uend = uend - 1
          iend = DECREMENT_INTERVAL
        end
        while ustart < uend
          amount += (DECREMENT_INTERVAL - istart) * GENERATION_AMOUNT[ustart]
          ustart += 1
          istart = 0
        end
        amount += (iend - istart) * GENERATION_AMOUNT[ustart]
      end
      amount += claim[:sysfee]
      amount_claimed += claim[:value] * amount
    end
    amount_claimed
  end
end
