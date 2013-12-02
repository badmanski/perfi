class EntriesController < InheritedResources::Base
  load_and_authorize_resource
  respond_to :json

  protected

  def collection
    @entries = current_user.entries
  end
end
