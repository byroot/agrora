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
  
  def edit
    @server = find_or_raise!(Server.where :hostname => params[:id])
  end
  
  def update
    @server = find_or_raise!(Server.where :hostname => params[:id])
    if @server.update_attributes(params[:server])
      redirect_to :action => :index
    else
      render :edit
    end
  end
  
end