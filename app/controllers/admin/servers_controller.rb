class Admin::ServersController < Admin::BaseController
  
  def index
    @servers = Server.all
  end
  
end