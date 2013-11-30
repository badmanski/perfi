class UsersController < InheritedResources::Base
  load_and_authorize_resource except: [:new, :create]

  def create
    create! { root_path }
  end

  def permitted_params
    params.permit(user: [:name, :email, :password, :password_confirmation])
  end
end
