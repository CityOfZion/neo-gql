class CreateAssets < ActiveRecord::Migration[5.1]
  def change
    create_table :assets do |t|
      t.string :asset_id
      t.string :asset_type
      t.string :name
      t.string :owner
      t.string :admin
      t.string :amount
      t.integer :precision
      t.timestamps
    end
  end
end
