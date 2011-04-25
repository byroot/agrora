class Admin::BaseController < ApplicationController
  
  layout 'admin'
  require_permission :view_admin
  
  def index
  end
  
end
