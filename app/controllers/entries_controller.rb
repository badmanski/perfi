class EntriesController < ApplicationController
  load_and_authorize_resource

  def create
    Entry.create(entry_params)
    balance = current_user.reload.balance
    redirect_to root_path, notice: t(:entry_created, balance: balance)
  end

  def destroy
    Entry.find_by(id: params[:id]).try(:destroy)
    balance = current_user.reload.balance
    redirect_to root_path,
                notice: t(:entry_destroyed, balance: balance),
                status: 303
  end

  private

  def entry_params
    params.require(:entry).permit(:name, :entry_type_id, :amount)
  end
end
