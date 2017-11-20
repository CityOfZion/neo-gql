class NeonController < ApplicationController

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
        unspent: Output.where(account: account).unclaimed(asset).map { |o| o.slice(:index, :txid, :value) }
      }
      memo
    end

    json balances.merge(address: params[:address])
  end

  # TODO: Not implemented
  def address_claims
    json total_claim: 0, total_unspent_claim: 0, address: params[:address], claims: []
  end

  # TODO: Not implemented
  def address_history
    json name: "transaction_history", address: params[:address], history: []
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
