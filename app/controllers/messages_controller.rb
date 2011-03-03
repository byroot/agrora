class MessagesController < BaseController
  
  require_permission :create_message, :only => [:new, :create]
  
  def new
    @message = Message.new(
      :parent_node => parent,
      :body => parent.body.gsub(/^/, '> ')
    )
  end
  
  def create
    @message = Message.new({:parent_node => parent}.merge(params[:message] || {}))
    if @message.save
      Resque.enqueue(Jobs::PostMessage, @message.indexes)
      anchor = "message-#{@message.indexes.join('-')}"
      redirect_to group_topic_path(group, topic, :anchor => anchor)
    else
      render :new
    end
  end
  
  def preview
    @message = Message.new(params[:message])
    render :preview, :layout => false
  end
  
  protected
  
  def parent
    @parent ||= topic.find_message_by_indexes(parent_indexes)
  end
  
  def parent_indexes
    (params[:parent] || '').split('-').map(&:to_i)
  end
  
  def topic
    @topic ||= find_or_raise!(RootNode.where :index => params[:topic_id].to_i, :groups => group.name)
  end
  
  def group
    @group ||= find_or_raise!(Group.where :name => params[:group_id])
  end
  
end