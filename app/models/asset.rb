class Asset < ApplicationRecord
  has_many :balances

  def self.import(txid, data)
    data['asset_id'] = txid
    data['asset_type'] = data.delete('type')
    create!(data)
  end
end
