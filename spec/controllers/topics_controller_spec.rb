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
      get :show, :group_id => 'comp.lang.ruby', :id => Topic.first.index.to_s
      response.should be_success
    end
    
    it 'should raise DocumentNotFound if topic does not exist' do
      expect{
        get :show, :group_id => 'comp.lang.ruby', :id => '42'
      }.to raise_error(Mongoid::Errors::DocumentNotFound)
    end
    
  end
  
end