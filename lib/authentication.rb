module Authentication

  protected

  def self.included(base)
    base.helper_method :current_user
  end

  def current_user
    @current_user ||= if session[:user_id]
      User.find(session[:user_id])
    else
      Anonymous.new
    end
  end

  def current_user=(user)
    session[:user_id] = user ? user._id.to_s : nil
    @current_user = user || false
  end

  def logout_keeping_session!
    @current_user = false
    session[:user_id] = nil
  end

  def logout_killing_session!
    reset_session
  end

end


