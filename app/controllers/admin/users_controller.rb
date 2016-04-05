class Admin::UsersController < ApplicationController
  def index
    @users = User.all.where(admin: false).order(:name)
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to admin_users_path
    else
      render 'new'
    end
  end

  def destroy
    User.destroy params[:id]
    redirect_to admin_users_path
  end

  private

  def user_params
    params.require(:user).permit(
      :name, :password, :email
    )
  end
end
