class DashboardController < ApplicationController
  def index
    if current_user
      render 'dashboard'
    else
      render 'landing'
    end
  end
end
