require 'spec_helper'

describe GroupsController do
  
  describe '#index' do
    
    before :each do
      Fabricate(:group)
    end
    
    it 'should be success' do
      get :index
      response.should be_success
    end
    
    it 'should list all groups' do
      get :index
      assigns(:groups).should_not be_empty
      assigns(:groups).length.should == Group.count
    end
    
  end
  
end
