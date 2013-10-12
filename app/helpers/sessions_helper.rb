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
    session[:local_session_token] = current_user.create_local_session(get_session_hash)

    @current_user != nil
  end

  def get_session_hash
    hash = {
      :remote_ip => request.remote_ip,
      :user_agent => request.env['HTTP_USER_AGENT'],
      :status => "ACTIVE",
      :location => (request.location.city || request.remote_ip)
    }
  end
end
