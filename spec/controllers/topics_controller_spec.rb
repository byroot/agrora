require 'spec_helper'

describe TopicsController do
  
  describe '#index' do
    
    before :each do
      @group = Fabricate(:group)
      @topic = Fabricate(:topic)
    end
    
    it 'should be success' do
      get :index, :group_id => 'comp.lang.ruby'
      response.should be_success
    end
    
    describe 'pagination' do
      
      before :each do
        100.times{ |i| Fabricate(:topic) }
      end
      
      it 'can change page size' do
        get :index, :group_id => 'comp.lang.ruby'
        assigns(:topics).size.should == 20
        
        get :index, :group_id => 'comp.lang.ruby', :per_page => 42
        assigns(:topics).size.should == 42
      end
      
      it 'can select page' do
        get :index, :group_id => 'comp.lang.ruby'
        assigns(:topics).size.should == 20
        assigns(:topics).should == Topic.where(:groups => 'comp.lang.ruby').paginate(:page => 1, :per_page => 20)
        
        get :index, :group_id => 'comp.lang.ruby', :page => 6
        assigns(:topics).size.should == 1
        assigns(:topics).should == Topic.where(:groups => 'comp.lang.ruby').paginate(:page => 6, :per_page => 20)
      end
      
    end
    
    it 'should trigger an UpdateGroup job if necessary' do
      expect{
        get :index, :group_id => 'comp.lang.ruby'
      }.to trigger(Jobs::UpdateGroup).with('comp.lang.ruby')
    end

    it 'should not trigger an UpdateGroup job if it is not necessary' do
      @group.update_attributes!(:last_synchronisation_at => DateTime.now)
      expect{
        get :index, :group_id => 'comp.lang.ruby'
      }.to_not trigger(Jobs::UpdateGroup)
    end
    
  end
  
  describe '#show' do
    
    before :each do
      @group = Fabricate(:group)
      @topic = Fabricate(:topic)
    end
    
    it 'should be success' do
      get :show, :group_id => 'comp.lang.ruby', :id => Topic.first.index.to_s
      response.should be_success
    end
    
    it 'should be succes if Topic#id is suffixed by a slug' do
      get :show, :group_id => 'comp.lang.ruby', :id => "#{Topic.first.index}-my-cool-slug"
      response.should be_success
    end
    
    it 'should raise DocumentNotFound if topic does not exist' do
      expect{
        get :show, :group_id => 'comp.lang.ruby', :id => '42'
      }.to raise_error(Mongoid::Errors::DocumentNotFound)
    end
    
    it 'should trigger an UpdateGroup job' do
      expect{
        get :show, :group_id => 'comp.lang.ruby', :id => Topic.first.index.to_s
      }.should trigger(Jobs::UpdateGroup).with('comp.lang.ruby')
    end
    
    it 'should not trigger an UpdateGroup job if it is not necessary' do
      @group.update_attributes!(:last_synchronisation_at => DateTime.now)
      expect{
        get :show, :group_id => 'comp.lang.ruby', :id => Topic.first.index.to_s
      }.to_not trigger(Jobs::UpdateGroup)
    end
    
  end
  
  describe "#new" do
    
    before :each do
      @group = Fabricate(:group)
    end
    
    it 'should be success' do
      get :new, :group_id => 'comp.lang.ruby'
      response.should be_success
    end
    
  end
  
  describe "#create" do
    
    before :each do
      @group = Fabricate(:group)
    end
    
    it 'should redirect to topic_path when successful' do
      expect{
        post :create, :group_id => 'comp.lang.ruby', :topic => {
          :author_email => 'foo@bar.org', :author_name => 'Foo Bar',
          :subject => 'Hello World !', :body => 'Egg Spam'
        }
        response.should be_redirect
        response.location.should == group_topic_url(@group, Topic.last)
      }.to change{ Topic.count }.by(1)
    end
    
    it 'should trigger a PostMessage job when successful' do
      expect{
        post :create, :group_id => 'comp.lang.ruby', :topic => {
          :author_email => 'foo@bar.org', :author_name => 'Foo Bar',
          :subject => 'Hello World !', :body => 'Egg Spam'
        }
        response.should be_redirect
      }.to trigger(Jobs::PostMessage).with([1])
    end
    
    it 'should render :new when creation failed' do
      post :create, :group_id => 'comp.lang.ruby', :topic => {
        :author_email => 'foo@bar.org', :author_name => 'Foo Bar'
      }
      controller.should render_template('new')
    end
    
    it 'should not trigger a PostMessage job when creation failed' do
      expect{
        post :create, :group_id => 'comp.lang.ruby', :topic => {
          :author_email => 'foo@bar.org', :author_name => 'Foo Bar'
        }
      }.to_not trigger(Jobs::PostMessage)
    end
    
  end
  
end