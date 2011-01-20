require 'spec_helper'

describe Admin::ServersController do
  
  describe '#index' do
    
    before :each do
      Fabricate :server
    end
    
    it 'should be success' do
      get :index
      response.should be_success
    end
    
    it 'should render all servers' do
      get :index
      assigns(:servers).should_not be_empty
      assigns(:servers).size.should == Server.count
    end
    
  end
  
  describe '#new' do
    
    it 'should be success' do
      get :new
      response.should be_success
    end
    
    it 'should provide a new Server' do
      get :new
      assigns(:server).should_not be_persisted
    end
    
  end
  
  describe '#create' do
    
    it 'should redirect to index when successful' do
      post :create, :server => { :hostname => 'news.example.org' }
      response.should be_redirect
      response.location.should == admin_servers_url
    end
    
    it 'should render :new when not successfull' do
      post :create
      controller.should render_template('new')
    end
    
  end
  
end