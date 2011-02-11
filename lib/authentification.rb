module Authentification

  protected

  def logged_in?
    !!current_user
  end


  def admin?
    logged_in? && current_user.admin?
  end

  def current_user
    @current_user ||= (login_from_session) unless @current_user == false
  end

  def current_user=(new_user)
    session[:user_id] = new_user ? new_user._id.to_s : nil
    @current_user = new_user || false
  end

  def login_from_session
    self.current_user = User.find(session[:user_id]) if session[:user_id]
  end

  def logout_keeping_session!
    @current_user = false
    session[:user_id] = nil
  end

  def logout_killing_session!
    reset_session
  end

  def store_location
    session[:return_to] = request.request_uri
  end

  def redirect_back_or_default(default)
    redirect_to (session[:return_to] || default)
    session[:return_to] = nil
  end

  def is_admin_or_raise!
    admin? or raise UnAuthorizedError.new
  end

  def logged_in_or_raise!
    logged_in? or raise UnAuthorizedError.new
  end

  def access_denied
    store_location
    redirect_to new_session_url
  end

end


class UnAuthorizedError < Exception
end
