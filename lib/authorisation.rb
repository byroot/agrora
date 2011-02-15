# this module depend of authentification module
module Authorisation

  protected

  def self.included m
    return unless m < ActionController::Base
    m.helper_method :logged_in?, :admin?
  end
  def store_location
    session[:return_to] = request.fullpath
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

  def logged_in?
    !!current_user
  end


  def admin?
    logged_in? && current_user.admin?
  end
end

class UnAuthorizedError < Exception
end
