class SessionsController < ApplicationController
  def new
    @user = User.new
    render :new
  end

  def create
    if login_user!
      redirect_to cats_url
    else
      flash.now[:errors] = ["Username or password invalid"]
      render :new
    end
  end

  def destroy
    current_user.reset_session_token! if logged_in?
    session[:session_token] = nil
    redirect_to new_session_url
  end
end
