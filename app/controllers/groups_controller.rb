class GroupsController < BaseController
  
  def index
    @groups = Group.all
  end
  
end