class UpdateBalanceJob < ApplicationJob
  queue_as :default

  def perform(account_id, asset_id)
    account = Account.find(account_id)
    asset = Asset.find(asset_id)

    account.update_balance(asset)
  end
end
