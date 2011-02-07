class ApplicationController < ActionController::Base
  protect_from_forgery
  
  def logged_in?
    !!current_user
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

  private
  
  def find_or_raise!(scope)
    scope.first or raise Mongoid::Errors::DocumentNotFound.new(scope, scope.selector)
  end

end
