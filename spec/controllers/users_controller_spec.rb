require 'spec_helper'

describe UsersController do

  describe '#new' do
    
    it 'should be success' do
      get :new
      response.should be_success
    end
  end

  describe '#create' do

    it 'should render :new if validation fail' do
      post :create, 
        :user => {:email => 'foo', :password => '', :password_confirmation => '', :username => ''}
      controller.should render_template('new')
    end

    it 'should redirect to root if success' do
      expect{
        post :create, 
          :user => {:email => 'foo@bar.com', :password => 'foobar', :password_confirmation => 'foobar',
            :username => 'foo'}
        response.should be_redirect
        response.should redirect_to(root_url)
      }.to change { User.count }.by(1)
    end
    
    it 'should not allow to specify a custom #password_salt' do
      expect{
        post :create, :user => {:email => 'foo@bar.com', :password => 'foobar',
          :password_confirmation => 'foobar', :username => 'foo', :password_salt => 'my_custom_salt'}
        response.should be_redirect
        response.should redirect_to(root_url)
      }.to change { User.count }.by(1)
      assigns(:user).password_salt.should be_present
      assigns(:user).password_salt.should_not == 'my_custom_salt'
    end
    
  end

  describe '#activate' do
    
    before :each do
      @user = Fabricate(:user)
    end
    
    it 'should redirect to root if token is not correct' do
      get :activate, :user_id => @user.id.to_s, :activation_token => 'foo'
      response.should be_redirect
      response.should redirect_to(root_url)
    end

    it 'should set activation_token to nil and redirect to groups#index' do
      expect{
        get :activate, :user_id => @user.id.to_s, :activation_token => @user.activation_token
        response.should be_redirect
        response.should redirect_to(root_url)
      }.to change{ @user.reload.activation_token }.to(nil)
    end

    it 'should activate user' do
      expect{
        get :activate, :user_id => @user.id.to_s, :activation_token => @user.activation_token
      }.to change{ @user.reload.state }.from('disabled').to('activated')
    end
    
  end
  
end
