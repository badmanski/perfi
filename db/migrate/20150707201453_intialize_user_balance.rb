class IntializeUserBalance < ActiveRecord::Migration
  def up
    User.all.each do |user|
      balance = user.entries.incomes.current_month.total_amount -
                user.entries.expenses.current_month.total_amount
      user.update_attributes(balance: balance)
    end
  end

  def down
    User.update_all(balance: 0)
  end
end
