class Admin::GroupsController < Admin::BaseController
  
  def index
    @groups = server.groups
  end
  
  def new
    @available_groups = available_groups
  rescue NNTPClient::NetworkFailureException => e
    @exception = e
  end
  
  def create
    @groups = (params[:groups] || []).map{ |g| Group.find_or_create_by(:name => g) }
    server.groups.substitute(@groups, :continue => true)
    if server.save
      redirect_to admin_server_url(server)
    else
      render :new
    end
  end
  
  protected
  
  def available_groups
    client.list.sort_by(&:name)
  end
  
  def server
    @server ||= find_or_raise!(Server.where :hostname => params[:server_id])
  end
  
  def client
    @client ||= NNTPClient.new(
      server.hostname,
      server.port,
      server.user,
      server.secret
    )
  end
  
end