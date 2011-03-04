require 'spec_helper'

describe MessagesController do
  
  describe '#new' do
    
    before :each do
      logged_in_as Fabricate(:user, :state => 'activated')
      @group = Fabricate(:group)
      @topic = Fabricate(:topic)
    end
    
    it 'should be success' do
      get :new, :group_id => 'comp.lang.ruby', :topic_id => @topic.index.to_s, :parent => '1-0-0'
      response.should be_success
    end
    
    it 'should raise DocumentNotFound if group does not exist' do
      expect{
        get :new, :group_id => 'comp.lang.rubie', :topic_id => '1', :parent => '0-0-0'
      }.to raise_error(Mongoid::Errors::DocumentNotFound)
    end

    it 'should raise DocumentNotFound if topic does not exist' do
      expect{
        get :new, :group_id => 'comp.lang.ruby', :topic_id => '42', :parent => '0-0-0'
      }.to raise_error(Mongoid::Errors::DocumentNotFound)
    end
    
    it 'should raise DocumentNotFound if parent does not exist' do
      pending 'Mongoid::Errors::DocumentNotFound require 2 arguments' do
        expect{
          get :new, :group_id => 'comp.lang.ruby', :topic_id => @topic.index.to_s, :parent => '42-12-24'
        }.to raise_error(Mongoid::Errors::DocumentNotFound)
      end
    end
    
  end
  
  describe '#create' do
    
    before :each do
      logged_in_as Fabricate(:user, :state => 'activated')
      @group = Fabricate(:group)
      @topic = Fabricate(:topic)
    end
    
    it 'should raise DocumentNotFound if group does not exist' do
      expect{
        post :create, :group_id => 'comp.lang.rubie', :topic_id => '1', :parent => '0-0-0'
      }.to raise_error(Mongoid::Errors::DocumentNotFound)
    end

    it 'should raise DocumentNotFound if topic does not exist' do
      expect{
        post :create, :group_id => 'comp.lang.ruby', :topic_id => '42', :parent => '0-0-0'
      }.to raise_error(Mongoid::Errors::DocumentNotFound)
    end
    
    it 'should raise DocumentNotFound if parent does not exist' do
      pending 'Mongoid::Errors::DocumentNotFound require 2 arguments' do
        expect{
          post :create, :group_id => 'comp.lang.ruby', :topic_id => @topic.index.to_s, :parent => '42-12-24'
        }.to raise_error(Mongoid::Errors::DocumentNotFound)
      end
    end
    
    it 'should render :new if validation fail' do
      post :create, :group_id => 'comp.lang.ruby', :topic_id => '1', :parent => '1-0', :message => {}
      controller.should render_template('new')
    end
    
    it 'should redirect_to message path with correct anchor if creation is successful' do
      expect{
        post :create, :group_id => 'comp.lang.ruby', :topic_id => '1', :parent => "1-0", :message => {
          :author_email => 'foo@bar.baz', :author_name => 'Foo Bar', :subject => 'Hello World', :body => 'Lorem Ipsum'
        }
        response.should be_redirect
        response.location.should ends_with('#message-1-0-2')
      }.to change { @topic.reload.find_message_by_indexes([1, 0, 2]) }.from(nil).to(instance_of(Message))
    end
    
    it 'should trigger a PostMessage job if creation is successful' do
      expect{
        post :create, :group_id => 'comp.lang.ruby', :topic_id => '1', :parent => '1-0', :message => {
          :author_email => 'foo@bar.baz', :author_name => 'Foo Bar', :subject => 'Hello World', :body => 'Lorem Ipsum'
        }
      }.to trigger(Jobs::PostMessage).with([1, 0, 2])
    end
    
    it 'should not trigger a PostMessage job if creation failed' do
      expect{
        post :create, :group_id => 'comp.lang.ruby', :topic_id => '1'
      }.to_not trigger(Jobs::PostMessage)
    end
    
  end
  
end
