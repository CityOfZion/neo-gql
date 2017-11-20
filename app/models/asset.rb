class Asset < ApplicationRecord
  has_many :balances

  def common_name
    _name = (name.find { |n| n['lang'] == 'en' } || name.first)['name']
    I18n.t(_name)
  end

  def self.import(txid, data)
    data['asset_id'] = txid
    data['asset_type'] = data.delete('type')
    Account.find_or_create_by(address: data['admin'])
    create!(data)
  end
end
