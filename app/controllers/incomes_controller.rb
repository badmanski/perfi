class IncomesController < ApplicationController
  respond_to :json

  def index
    respond_with current_user.entries.incomes
  end

  def create
    respond_with Entry.create(safe_params)
  end

  def safe_params
    params.require(:income).permit(:name, :entry_type_id, :amount)
  end
end
