class DropPeriods < ActiveRecord::Migration
  def up
    drop_table :periods
  end

  def down
    fail ActiveRecord::IrreversibleMigration
  end
end
