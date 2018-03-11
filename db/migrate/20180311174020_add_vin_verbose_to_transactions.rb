class AddVinVerboseToTransactions < ActiveRecord::Migration[5.1]
  def change
    add_column :transactions, :vin_verbose, :jsonb
  end
end
