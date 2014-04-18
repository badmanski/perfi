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

  def chart_data
    render json: current_user.try(:chart_data)
  end

  def init_vars
    init_types
    init_entries
  end

  def init_types
    types = current_user.entry_types
    @types = {}
    @types[:incomes] = types.incomes
    @types[:expenses] = types.expenses
  end

  def init_entries
    entries = current_user.current_month_entries.desc
    @entries = {}
    @entries[:incomes] = entries.incomes
    @entries[:expenses] = entries.expenses
    @entries[:total_incomes] = entries.incomes.total_amount
    @entries[:total_expenses] = entries.expenses.total_amount
    @entries[:balance] = @entries[:total_incomes] - @entries[:total_expenses]
  end
end
