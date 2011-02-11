require 'spec_helper'

describe Admin::GroupsController do
  
  describe '#index' do
    
    before :each do
      @server = Fabricate(:server)
    end
    
    it 'should be success' do
      get :index, :server_id => 'news.example.com'
      response.should be_success
    end
    
    it 'should render all groups' do
      get :index, :server_id => 'news.example.com'
      assigns(:groups).size.should == 2
    end
    
  end
  
  describe '#new' do
    
    before :each do
      @server = Fabricate(:server)
      Fabricate(:group, :servers => [@server])
      Fabricate(:group, :name => 'comp.lang.python', :servers => [@server])
      @available_groups = %w(comp.lang.c comp.lang.php comp.lang.python comp.lang.ruby).map{ |g| NNTPClient::Group.new(g) }
      controller.stub!(:available_groups => @available_groups)
    end
    
    it 'should be success' do
      get :new, :server_id => 'news.example.com'
      response.should be_success
    end
    
    it 'should provide available groups' do
      get :new, :server_id => 'news.example.com'
      assigns(:available_groups).should == @available_groups
      assigns(:exception).should be_nil
    end
    
    it 'in case of network failure it should provide the exception' do
      @exception = NNTPClient::NetworkFailureException.new("Connection refused")
      controller.should_receive(:available_groups).and_raise(@exception)
      get :new, :server_id => 'news.example.com'
      assigns(:exception).should == @exception
    end
    
  end
  
  describe '#create' do
    
    before :each do
      @server = Fabricate(:server)
      Fabricate(:group, :servers => [@server])
      Fabricate(:group, :name => 'comp.lang.python', :servers => [@server])
      @available_groups = %w(comp.lang.c comp.lang.php comp.lang.python comp.lang.ruby).map{ |g| NNTPClient::Group.new(g) }
      controller.stub!(:available_groups => @available_groups)
    end
    
    it 'should update group list' do
      expect{
        post :create, :server_id => 'news.example.com', :groups => %w(comp.lang.c comp.lang.php)
      }.to change{ @server.reload.groups.map(&:name).sort }.from(%w(comp.lang.python comp.lang.ruby)).to(%w(comp.lang.c comp.lang.php))
      assigns(:groups).each{ |g| g.server_ids.should include(@server.id) }
    end
    
    it 'should redirect to server index if successful' do
      post :create, :server_id => 'news.example.com', :groups => %w(comp.lang.c comp.lang.php)
      response.should be_redirect
      response.location.should == admin_server_url(@server)
    end
    
    it 'should trigger update for groups newly added' do
      expect{
        post :create, :server_id => 'news.example.com', :groups => %w(comp.lang.c)
      }.to trigger(Jobs::UpdateGroup).with('comp.lang.c')
    end
    
    it 'should destroy orphan groups' do
      @group = Group.first(:conditions => {:name => 'comp.lang.python'})
      @other_server = Fabricate(:server, :hostname => 'news.fox.org', :groups => [@group])
      @group.save
      
      expect{
        post :create, :server_id => 'news.example.com', :groups => []
      }.to change{ Group.count }.by(-1)
    end
    
  end
  
end
