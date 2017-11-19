# TODO: Cleanup empty balances
class Balance < ApplicationRecord
  belongs_to :account
  belongs_to :asset
end
