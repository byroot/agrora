class Admin::ServersController < Admin::BaseController
  
  def index
    @servers = Server.all
  end
  
  def new
    @server = Server.new
  end
  
  def create
    @server = Server.new(params[:server])
    if @server.save
      redirect_to :action => :index
    else
      render :new
    end
  end
  
end