class SessionsController < ApplicationController

  def new
  end

  def create
    if self.current_user = User.authenticate(params[:email], params[:password])
      flash[:notice] = "Logged in successfully."
      redirect_to params[:redirect].presence || groups_url
    else
      flash.now[:error] = "Invalid login or password."
      render :new
    end
  end

  def destroy
    logout_killing_session!
    flash[:notice] = "You have been logged out."
    redirect_to root_url
  end

end
