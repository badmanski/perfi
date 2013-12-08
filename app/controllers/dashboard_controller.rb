class DashboardController < ApplicationController
  def index
    if current_user
      init_vars
      render 'dashboard'
    else
      render 'landing'
    end
  end

  def init_vars
    @income_types = current_user.entry_types.incomes
    @expense_types = current_user.entry_types.expenses
  end
end
