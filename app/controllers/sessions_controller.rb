class SessionsController < ApplicationController

  def new
  end

  def create
    user = User.find_by_credentials(params[:username], params[:password])
    # fail
    if user
      login!(user)
      redirect_to user_url
    else
      flash[:notice] = "Invalid username or password."
      redirect_to new_session_url
    end
  end

  def destroy
    logout!
    redirect_to new_session_url
  end

end
