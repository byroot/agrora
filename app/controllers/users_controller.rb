class UsersController < ApplicationController

  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      UserMailer.activation_mail(@user).deliver
      redirect_to root_url
    else
      render :new
    end
  end

  def activate
    logout_keeping_session!
    if params[:activation_token].blank? || params[:user_id].blank?
      flash[:error] = "The activation code was missing. Please follow the URL from your email."
    elsif self.current_user = User.activate(params[:user_id], params[:activation_token])
      flash[:notice] = "Account Activated."
    else
      flash[:error] = "We couldn't find a user with that activation code -- check your email? Or maybe you've already activated -- try signing in."
    end
    redirect_to root_url
  end
  
end
