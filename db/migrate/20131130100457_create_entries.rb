class CreateEntries < ActiveRecord::Migration
  def change
    create_table :entries do |t|
      t.string :name
      t.decimal :amount
      t.integer :entry_type_id
      t.integer :period_id

      t.timestamps
    end
  end
end
