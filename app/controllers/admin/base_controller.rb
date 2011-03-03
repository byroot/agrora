class Admin::BaseController < ApplicationController
  
  require_permission :view_admin
  
  def index
  end
  
end