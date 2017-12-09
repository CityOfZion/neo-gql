class UpdateBalanceJob < ApplicationJob
  queue_as :default

  def perform(output)
    output.account.update_balance output.asset
  end
end
