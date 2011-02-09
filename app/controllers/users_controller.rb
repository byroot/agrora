class UsersController < ApplicationController
  def index
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      redirect_to '/'
    else
      render :new
    end
  end

  def activate
    logout_keeping_session!
    if params[:token].blank?
      flash[:error] = "The activation code was missing. Please follow the URL from your email."
      redirect_to '/'
    end

    user = User.find(:first, :conditions => {:activation_token => params[:token]})
    if user && !user.active?
      user.activate!
      self.current_user = user
      flash[:notice] = "Account Activated."
      redirect_to groups_path
    else
      flash[:error] = "We couldn't find a user with that activation code -- check your email? Or maybe you've already activated -- try signing in."
      redirect_to '/'
    end
  end
end
