# TODO: Cleanup accounts with no balances
class Account < ApplicationRecord
  has_many :balances
  has_many :outputs

  def update_balance(asset)
    new_balance = outputs.unclaimed(asset).sum(:value)
    balances.find_or_create_by(asset: asset).update_attribute(:value, new_balance)
  end
end
