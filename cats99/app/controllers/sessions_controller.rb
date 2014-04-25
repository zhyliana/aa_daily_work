class SessionsController < ApplicationController

  before_action :redirect_logged_in

  def new
    render :new
  end

  def create
    @user = User.find_by_credentials(params[:user])

    if @user
       login!(@user)
       redirect_to user_url(@user)
    else
      flash.now[:errors] = "Invalid username/password"
      redirect_to new_user_url
    end
  end

  def destroy
    @session.reset_session_token!
    render :new
  end

  def redirect_logged_in
    redirect_to cats_url if logged_in?
  end
end
