class Admin::ServersController < Admin::BaseController
  
  before_filter :server, :only => [:show, :edit]
  
  def index
    @servers = Server.all
  end
  
  def show
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
  end
  
  def update
    if server.update_attributes(params[:server])
      redirect_to :action => :index
    else
      render :edit
    end
  end
  
  def destroy
    server.destroy
    redirect_to :action => :index
  end
  
  protected
  
  def server
    @server = find_or_raise!(Server.where :hostname => params[:id])
  end
  
end
