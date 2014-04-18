class EntriesController < InheritedResources::Base
  load_and_authorize_resource

  def create
    create! { root_path }
  end

  protected

  def permitted_params
    params.permit(entry: [:name, :entry_type_id, :amount])
  end
end
