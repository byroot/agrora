class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.authenticate(params[:email], params[:password])
    if user
      self.current_user = user

      flash[:notice] = "Logged in successfully."
      redirect_to params[:redirect] || groups_url
    else
      #logout_killing_session!
      flash.now[:error] = "Invalid login or password."
      render :action => 'new'
    end
  end

  def destroy
    logout_killing_session!
    flash[:notice] = "You have been logged out."
    redirect_to root_url
  end
end
