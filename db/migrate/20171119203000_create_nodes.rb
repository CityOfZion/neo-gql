class CreateNodes < ActiveRecord::Migration[5.1]
  def change
    create_table :nodes do |t|
      t.string :url
      t.bigint :block_height
      t.boolean :status
      t.float :time
      t.timestamps
    end
  end
end
