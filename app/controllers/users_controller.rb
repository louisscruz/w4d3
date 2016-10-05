class UsersController < ApplicationController
  before_action :set_user, only: [:show]

  def new
  end

  def create
    user = User.new(user_params)
    if user.save
      redirect_to user_url(user)
    else
      render :new
    end
  end

  def show
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:user_name, :password)
  end
end
