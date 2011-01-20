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
  
  describe '#show' do
    
    before :each do
      Fabricate :server
    end
    
    it 'should be success' do
      get :show, :id => 'news.example.com'
      response.should be_success
    end
    
    it 'should raise DocumentNotFound if server does not exist' do
      expect{
        get :edit, :id => 'does.not.exist'
      }.to raise_error(Mongoid::Errors::DocumentNotFound)
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
      expect{
        post :create, :server => { :hostname => 'news.example.org' }
      }.to change { Server.count }.by(1)
      response.should be_redirect
      response.location.should == admin_servers_url
    end
    
    it 'should render :new when not successfull' do
      post :create
      controller.should render_template('new')
    end
    
  end
  
  describe '#edit' do
    
    before :each do
      Fabricate :server
    end
    
    it 'should raise DocumentNotFound if server does not exist' do
      expect{
        get :edit, :id => 'does.not.exist'
      }.to raise_error(Mongoid::Errors::DocumentNotFound)
    end
    
    it 'should be success' do
      get :edit, :id => 'news.example.com'
      response.should be_success
      assigns(:server).hostname.should == 'news.example.com'
    end
    
  end
  
  describe '#update' do
    
    before :each do
      Fabricate :server
    end
    
    it 'should redirect to index when successfull' do
      post :update, :id => 'news.example.com', :server => { :hostname => 'news.example.com', :port => 242 }
      response.should be_redirect
      response.location.should == admin_servers_url
    end
    
    it 'should raise DocumentNotFound if server does not exist' do
      expect{
        post :update, :id => 'does.not.exist'
      }.to raise_error(Mongoid::Errors::DocumentNotFound)
    end
    
    it 'should render :edit when not successful' do
      post :update, :id => 'news.example.com', :server => { :hostname => 'news.example.com', :port => 'blah' }
      controller.should render_template('edit')
    end
    
    it 'can change server hostname' do
      expect{
        post :update, :id => 'news.example.com', :server => { :hostname => 'news.free.fr', :port => 119 }
      }.to change{ Server.where(:hostname => 'news.free.fr').count }.from(0).to(1)
    end
    
  end
  
  describe '#destroy' do
    
    before :each do
      Fabricate :server
    end
    
    it 'should raise DocumentNotFound if server does not exist' do
      expect{
        post :destroy, :id => 'does.not.exist'
      }.to raise_error(Mongoid::Errors::DocumentNotFound)
    end
    
    
    it 'should delete server' do
      expect{
        post :destroy, :id => 'news.example.com'
      }.to change{ Server.count }.by(-1)
    end
    
  end
  
end