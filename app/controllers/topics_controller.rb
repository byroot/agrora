class TopicsController < BaseController
  
  include Paginate::ControllerExtension
  
  before_filter :trigger_group_update_if_necessary!
  
  require_permission :create_message, :only => [:new, :create]
  
  def index
    @topics = paginate(group.topics.order_by(:updated_at.desc))
  end
  
  def show
    @topic = find_or_raise!(RootNode.where :index => params[:id].to_i, :groups => group.name)
  end
  
  def new
    @topic = Topic.new
  end
  
  def create
    @topic = Topic.new(topic_params)
    if @topic.save
      Resque.enqueue(Jobs::PostMessage, @topic.indexes)
      redirect_to group_topic_path(group, @topic)
    else
      render :new
    end
  end
  
  protected
  
  def topic_params
    params[:topic].merge(:groups => [group.name], :author => current_user)
  end
  
  def group
    @group ||= find_or_raise!(Group.where :name => params[:group_id])
  end
  
  def trigger_group_update_if_necessary!
    Resque.enqueue(Jobs::UpdateGroup, group.name) if group.last_synchronisation_at < 10.minutes.ago
  end
  
  def pagination_params
    DEFAULT_PAGINATION_PARAMS.merge(params.slice(:page, :per_page)).symbolize_keys
  end
  
end
