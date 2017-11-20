class CreateBlocks < ActiveRecord::Migration[5.1]
  def change
    create_table :blocks do |t|
      t.bigint :index, index: true
      t.integer :time
      t.integer :size
      t.integer :version
      t.string :merkle_root
      t.string :nonce
      t.string :next_consensus
      t.string :block_hash
      t.string :prev_block_hash
      t.string :next_block_hash
      t.jsonb :script
      t.jsonb :tx
      t.timestamps
    end
  end
end
