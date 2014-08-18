class RenameUserBalance < ActiveRecord::Migration
  def change
    rename_column :users, :current_balance, :balance
  end
end
