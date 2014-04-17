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
    entries = current_user.entries.current_month.desc
    types = current_user.entry_types
    @user_data = {}
    @user_data[:income_types] = types.incomes
    @user_data[:expense_types] = types.expenses
    @user_data[:incomes] = entries.incomes
    @user_data[:expenses] = entries.expenses
  end
end
