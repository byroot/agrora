class MessagesController < ApplicationController
  
  def new
    @message = parent.responses.build
  end
  
  def create
    @message = parent.responses.build(params[:message])
    if @message.save
      anchor = "message-#{@message.indexes.join('-')}"
      redirect_to group_topic_path(group, topic, :anchor => anchor)
    else
      render :new
    end
  end
  
  protected
  
  def parent
    @parent ||= topic.find_message_by_indexes((params[:parent] || '').split('-').map(&:to_i))
  end
  
  def topic
    @topic ||= find_or_raise!(Topic.where :index => params[:topic_id], :groups => group.name)
  end
  
  def group
    @group ||= find_or_raise!(Group.where :name => params[:group_id])
  end
  
end