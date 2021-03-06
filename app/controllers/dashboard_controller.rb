class DashboardController < ApplicationController
  skip_before_filter :authenticate_user!

  def index
    if current_user
      init_vars
      render 'dashboard'
    else
      render 'landing'
    end
  end

  def init_vars
    init_types
    init_entries
    init_new_entry
  end

  private

  def init_types
    types = current_user.entry_types
    @types = {
      t(:expense, count: 2) => types.expenses.map { |x| [x.name, x.id] },
      t(:income, count: 2) => types.incomes.map { |x| [x.name, x.id] }
    }
  end

  def init_entries
    entries = current_user.entries.current_month.desc
    @entries = {}
    @entries[:incomes] = entries.incomes.page(params[:page_incomes]).per(5)
    @entries[:expenses] = entries.expenses.page(params[:page_expenses]).per(5)
    @entries[:total_incomes] = entries.incomes.total_amount
    @entries[:total_expenses] = entries.expenses.total_amount
    @entries[:balance] = current_user.balance
  end

  def init_new_entry
    @entry = Entry.new
  end
end
