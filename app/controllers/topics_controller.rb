class TopicsController < ApplicationController
  
  before_filter :trigger_group_update_if_necessary!
  
  def index
    @topics = group.topics.limit(50) # TODO: pagination
  end
  
  def show
    @topic = find_or_raise!(Topic.where :index => params[:id], :groups => group.name)
  end
  
  protected
  
  def group
    @group ||= find_or_raise!(Group.where :name => params[:group_id])
  end
  
  def trigger_group_update_if_necessary!
    Resque.enqueue(Jobs::UpdateGroup, group.name) if group.last_synchronisation_at < 10.minutes.ago
  end
  
end