class CreateAccounts < ActiveRecord::Migration[5.1]
  def change
    create_table :accounts do |t|
      t.string :address
      t.string :script_hash
      t.timestamps
    end
  end
end
