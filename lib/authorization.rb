# this module depend of authentification module
module Authorization
  
  PermissionRequired = Class.new(Exception)
  
  protected

  def self.included(base)
    base.rescue_from PermissionRequired, :with => :access_denied 
    base.helper_method :logged_in?, :admin?
  end
  
  def store_location
    session[:return_to] = request.fullpath
  end

  def redirect_back_or_default(default)
    redirect_to (session[:return_to] || default)
    session[:return_to] = nil
  end

  def is_admin_or_raise!
    admin? or raise PermissionRequired.new("You're not an admin")
  end

  def logged_in_or_raise!
    logged_in? or raise PermissionRequired.new("You should loggin")
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
