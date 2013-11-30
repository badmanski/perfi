class SessionsController < ApplicationController
  def new
    render layout: 'login'
  end

  def create
    user = User.find_by(email: params[:email])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to root_path, success: t(:login_successful, user: user.name)
    else
      redirect_to login_path, error: t(:login_failed)
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path, notice: t(:logout_successful)
  end
end
