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
    future_groups = params[:groups] || []
    current_groups = server.groups.map(&:name)
    new_groups = future_groups - current_groups
    old_groups = current_groups - future_groups
    
    @groups = future_groups.map{ |g| Group.find_or_create_by(:name => g) }
    server.groups.tap(&:nullify).substitute(@groups, :continue => true)
    if server.save
      # Trigger update for groups newly created
      new_groups.each{ |g| Resque.enqueue(Jobs::UpdateGroup, g) }
      
      # Destroy orphan groups
      old_groups.each do |group_name|
        group = Group.first(:conditions => {:name => group_name})
        group.destroy if group.servers.empty?
      end
      
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
