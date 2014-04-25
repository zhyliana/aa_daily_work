class UsersController < ApplicationController
  before_action :redirect_logged_in

  def new
    @user = User.new
    render :new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      login!(@user)
      flash[:notice] = '"#{@user.user_name}" has been added to our users list!'
      redirect_to user_url(@user)
    else
      flash.now[:notice] = '"#{@user.user_name}" has NOT been added to our users list!'
      render :new
    end
  end

  private
  def user_params
    params.require(:user).permit(:user_name, :password)
  end

  def redirect_logged_in
    redirect_to cats_url if logged_in?
  end
end
