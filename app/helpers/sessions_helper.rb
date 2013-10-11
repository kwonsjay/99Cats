module SessionsHelper
  def current_user
    @current_user ||= User.find_by_session_token(session[:session_token])
  end

  def logged_in?
    current_user != nil
  end

  def login_user!
    @current_user = User.find_by_credentials(params[:user][:user_name], params[:user][:password])
    return false if @current_user.nil?
    session[:session_token] = current_user.session_token

    @current_user != nil
  end
end
