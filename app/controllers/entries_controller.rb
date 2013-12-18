class EntriesController < InheritedResources::Base
  load_and_authorize_resource
  respond_to :json

  def incomes
    @incomes = @entries.incomes
  end

  def expenses
    @expenses = @entries.expenses
  end

  protected

    def collection
      @entries = current_user.entries
    end

    def permitted_params
      params.permit(entry: [:name, :entry_type_id, :amount])
    end
end
