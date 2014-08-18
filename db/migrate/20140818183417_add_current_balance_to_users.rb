class AddCurrentBalanceToUsers < ActiveRecord::Migration
  def change
    add_column :users, :current_balance, :decimal, null: false, default: 0
  end
end
