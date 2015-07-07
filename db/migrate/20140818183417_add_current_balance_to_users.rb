class AddCurrentBalanceToUsers < ActiveRecord::Migration
  def change
    add_column :users, :balance, :decimal, null: false, default: 0
  end
end
