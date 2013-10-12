class SessionsController < ApplicationController
  before_filter :user_logged_out, :only => [:new, :create]
  before_filter :remove_local_sessions, :only => [:create]

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

  def index
    @sessions = current_user.active_local_sessions
    render :index
  end

  def destroy
    if logged_in?
      # current_user.reset_session_token!
      params[:sessions] ||= []
      current_user.end_local_sessions(params[:sessions].map(&:to_i))
      # current_user.end_local_session(session[:local_session_token])
    end

    session[:session_token] = nil
    session[:local_session_token] = nil
    @current_user = nil
    redirect_to new_session_url
  end


  private
    def remove_local_sessions
      if session[:local_session_token]
        current_user.end_local_session(session[:local_session_token])
        session[:local_session_token] = nil
      end
    end

    def user_logged_out
      unless current_user.nil?
        redirect_to cats_url
      end

      true
    end
end
