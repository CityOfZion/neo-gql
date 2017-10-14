class CreateOutputs < ActiveRecord::Migration[5.1]
  def change
    create_table :outputs do |t|
      t.references :transaction
      t.references :address
      t.references :asset
      t.integer :index
      t.bigint :value
      t.boolean :claimed, default: false
      t.timestamps
    end
  end
end
