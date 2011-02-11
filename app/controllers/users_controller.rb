class UsersController < ApplicationController

  before_filter :is_admin_or_raise!

  def index
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      redirect_to root_url
    else
      render :new
    end
  end

  def activate
    logout_keeping_session!
    if params[:activation_token].blank?
      flash[:error] = "The activation code was missing. Please follow the URL from your email."
      redirect_to root_url
    end

    user = User.find(:first, :conditions => {:activation_token => params[:activation_token]})
    if user && !user.active?
      user.activate!
      self.current_user = user
      flash[:notice] = "Account Activated."
      redirect_to groups_path
    else
      flash[:error] = "We couldn't find a user with that activation code -- check your email? Or maybe you've already activated -- try signing in."
      redirect_to root_url
    end
  end
end
