class CreateEntryTypes < ActiveRecord::Migration
  def change
    create_table :entry_types do |t|
      t.string :name
      t.integer :user_id
      t.decimal :amount
      t.boolean :positive

      t.timestamps
    end
  end
end
