require 'spec_helper'

describe SessionsController do
  
  before :each do
    @user = Fabricate(:user)
  end
  
  describe '#create' do
    it 'should render new if fail' do
      post :create, :email => 'test', :password => 'foo'
      controller.should render_template('new')
    end
    
    it 'should fail if user is not activate' do
      post :create, :email => 'test@example.com', :password => 'azerty'
      controller.should render_template('new')
    end
    
    it 'should redirect to groups root if success' do
      expect{
        @user.activate!
        post :create, :email => 'test@example.com', :password => 'azerty'
        response.should redirect_to(groups_url)
      }.to change{assigns(:current_user)}.from(nil).to(@user.reload)
    end
  end

  describe '#destroy' do
    
    it 'should redirect to root' do
      post :destroy
      response.should be_redirect
      response.should redirect_to(root_url)
    end
    
  end

end
