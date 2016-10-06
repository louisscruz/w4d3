class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by_credentials(session_params[:user_name],session_params[:password])
    if user
      unless SessionToken.find_by(user_id: user.id).include?(session[:session_token])
        SessionToken.generate_new_token(user.id)
      end
      login(user)
      redirect_to cats_url
    else
      redirect_to new_session_url
    end
  end

  def destroy
    logout(current_user)
    redirect_to new_session_url
  end

  private
  def session_params
    params.require(:user).permit(:user_name, :password)
  end
end
