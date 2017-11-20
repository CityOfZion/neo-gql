class Output < ApplicationRecord
  belongs_to :account
  belongs_to :asset
  # called 'spending_transaction' because 'transaction' is reserved by Rails
  belongs_to :spending_transaction,
    foreign_key: 'transaction_id',
    class_name: 'Transaction'

  scope :unclaimed, -> (asset) { where(claimed: false, asset: asset) }

  delegate :txid, to: :spending_transaction

  def self.import(data)
    data['index'] = data.delete('n')
    data['asset'] = Asset.find_by(asset_id: data.delete('asset'))
    data['account'] = Account.find_or_create_by(address: data.delete('address'))
    create!(data).account.reload.update_balance(data['asset'])
  end

  def self.claim(txid, index)
    Transaction.unscoped.find_by_txid(txid).outputs.find_by_index(index).claim
  end

  def claim
    update_attribute :claimed, true
    account.update_balance(asset)
  end
end
