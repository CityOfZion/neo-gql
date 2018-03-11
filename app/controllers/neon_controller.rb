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

  # TODO: Not implemented
  def address_claims
    json total_claim: 0, total_unspent_claim: 0, address: params[:address], claims: []
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
        txid: tx.txid,
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
end
