class CreateBalances < ActiveRecord::Migration[5.1]
  def change
    create_table :balances do |t|
      t.references :asset
      t.references :account
      t.bigint :value
      t.timestamps
    end
  end
end
