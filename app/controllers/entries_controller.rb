class EntriesController < InheritedResources::Base
  respond_to :json

  protected

  def collection
    @entries = current_user.entries
  end
end
