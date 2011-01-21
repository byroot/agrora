class TopicsController < ApplicationController
  
  def index
    @topics = group.topics.limit(50) # TODO: pagination
  end
  
  def show
    @topic = Topic.find params[:id]
  end
  
  def group
    @group = find_or_raise!(Group.where :name => params[:group_id])
  end
  
end