class CreateTransactions < ActiveRecord::Migration[5.1]

  def change
    create_table :transactions do |t|
      t.references :block
      t.integer :size
      t.integer :version
      t.string :txid
      t.string :tx_type
      t.string :sys_fee
      t.string :net_fee
      t.json :data
      t.json :tx_attributes
      t.json :vin
      t.json :vout
      t.json :scripts
      t.timestamps
    end
  end
end
