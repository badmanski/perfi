class DropPeriodTypes < ActiveRecord::Migration
  def up
    drop_table :period_types
  end

  def down
    fail ActiveRecord::IrreversibleMigration
  end
end
