class EntryTypesController < InheritedResources::Base
  load_and_authorize_resource

  def create
    create! { entry_types_path }
  end

  def update
    update! { entry_types_path }
  end

  protected

  def collection
    @entry_types = current_user.entry_types
  end

  private

  def permitted_params
    params.permit(entry_type: [:name, :user_id, :amount, :positive])
  end
end
