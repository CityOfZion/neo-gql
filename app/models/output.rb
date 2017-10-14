class Output < ApplicationRecord
  belongs_to :address
  belongs_to :asset
  # called 'spending_transaction' because 'transaction' is reserved by Rails
  belongs_to :spending_transaction,
    foreign_key: 'transaction_id',
    class_name: 'Transaction'

  def self.import(data)
    data['index'] = data.delete('n')
    data['asset'] = Asset.find_by(asset_id: data.delete('asset'))
    data['address'] = Address.find_or_create_by(address: data.delete('address'))
    create!(data).update_balance
  end

  def self.claim(txid, index)
    Transaction.unscoped.find_by_txid(txid).outputs.find_by_index(index).claim
  end

  def update_balance
    address.balances.find_or_create_by(asset: asset).update_attribute(:value, value)
  end

  def claim
    update_attribute :claimed, true
  end
end
