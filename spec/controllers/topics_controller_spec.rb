require 'spec_helper'

describe TopicsController do
  
  describe '#index' do
    
    before :each do
      Fabricate(:group)
      Fabricate(:topic)
    end
    
    it 'should be success' do
      get :index, :group_id => 'comp.lang.ruby'
      response.should be_success
    end
    
    it 'should paginate topics'
    
  end
  
  describe '#show' do
    
    before :each do
      Fabricate(:group)
      Fabricate(:topic)
    end
    
    it 'should be success' do
      get :show, :group_id => 'comp.lang.ruby', :id => Topic.first.id
      response.should be_success
    end
    
  end
  
end