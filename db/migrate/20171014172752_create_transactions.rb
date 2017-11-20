class CreateTransactions < ActiveRecord::Migration[5.1]

  def change
    create_table :transactions do |t|
      t.references :block
      t.integer :size
      t.integer :version
      t.string :txid
      t.string :tx_type
      t.bigint :sys_fee
      t.bigint :net_fee
      t.jsonb :data
      t.jsonb :tx_attributes
      t.jsonb :vin
      t.jsonb :vout
      t.jsonb :scripts
      t.timestamps
    end
  end
end
