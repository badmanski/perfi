class CreatePeriods < ActiveRecord::Migration
  def change
    create_table :periods do |t|
      t.string :name
      t.date :start_date
      t.date :end_date
      t.integer :user_id
      t.integer :period_type_id

      t.timestamps
    end
  end
end
