class CreateAssets < ActiveRecord::Migration[5.1]
  def change
    create_table :assets do |t|
      t.string :asset_id
      t.string :asset_type
      t.string :owner
      t.string :admin
      t.string :amount
      t.integer :precision
      t.jsonb :name
      t.timestamps
    end
  end
end
