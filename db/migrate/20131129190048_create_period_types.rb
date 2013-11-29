class CreatePeriodTypes < ActiveRecord::Migration
  def change
    create_table :period_types do |t|
      t.string :name

      t.timestamps
    end
  end
end
