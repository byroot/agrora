require 'spec_helper'

describe SessionsController do
  
  before :each do
    @user = Fabricate(:user)
  end
  
  describe '#new' do
    
    it 'should be success' do
      get :new
      response.should be_success
    end
    
  end
  
  describe '#create' do
    
    it 'should render new if fail' do
      post :create, :email => 'test', :password => 'foo'
      controller.should render_template('new')
    end
    
    it 'should fail if user is not activated' do
      post :create, :email => 'test@example.com', :password => 'azerty'
      controller.should render_template('new')
    end
    
    it 'should redirect to groups root if success' do
      expect{
        @user.activate!
        post :create, :email => 'test@example.com', :password => 'azerty'
        response.should be_redirect
        response.should redirect_to(groups_url)
      }.to change{ assigns(:current_user) }.from(nil).to(@user.reload)
    end
    
    it 'should redirect to redirect params if success and params is present' do
      expect{
        @user.activate!
        post :create, :email => 'test@example.com', :password => 'azerty', :redirect => '/foo/bar'
        response.should be_redirect
        response.should redirect_to('/foo/bar')
      }.to change{ assigns(:current_user) }.from(nil).to(@user.reload)
    end
    
  end

  describe '#destroy' do
    
    before :each do
      logged_in_as @user
    end
    
    it 'should redirect to root' do
      post :destroy
      response.should be_redirect
      response.should redirect_to(root_url)
    end
    
    it 'should remove :user_id from session' do
      expect{
        post :destroy
      }.to change{ session[:user_id] }.from(@user.id.to_s).to(nil)
    end
    
  end

end
