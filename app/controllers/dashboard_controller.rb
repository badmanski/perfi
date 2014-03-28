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
    @income_types = current_user.entry_types.incomes
    @expense_types = current_user.entry_types.expenses
  end
end
