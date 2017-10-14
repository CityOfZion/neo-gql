class Transaction < ApplicationRecord
  belongs_to :block
  has_many :outputs

  def self.import(data)
    tx = data.extract!('txid', 'size', 'version', 'vin', 'vout', 'scripts', 'sys_fee', 'net_fee')
    case data['type']
    when 'MinerTransaction'
      tx['data'] = data.extract!('nonce')
    when 'ClaimTransaction'
      tx['data'] = data.extract!('claims')
    when 'RegisterTransaction'
      tx['data'] = data.extract!('asset')
      Asset.import(tx['txid'], tx['data']['asset'].deep_dup)
    when 'EnrollmentTransaction'
      tx['data'] = data.extract!('pubkey')
    when 'PublishTransaction'
      tx['data'] = data.extract!('contract')
    when 'InvocationTransaction'
      tx['data'] = data.extract!('script', 'gas')
    else
      tx['data'] = {}
    end
    tx['tx_type'] = data.delete('type')
    tx['tx_attributes'] = data.delete('attributes')
    raise "Unused TX Data: #{data} in #{tx}" unless data.empty?
    create!(tx).update_outputs
  end

  def update_outputs
    vin.each { |input| Output.claim(*input.values_at('txid', 'vout')) }
    vout.each { |output| outputs.import(output.dup) }
  end
end
