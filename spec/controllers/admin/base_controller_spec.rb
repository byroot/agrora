require 'spec_helper'

describe Admin::BaseController do
  
  before :each do
    logged_in_as Fabricate(:user, :state => 'activated', :is_admin => true)
  end
  
  describe '#index' do
    
    it 'should be success' do
      get :index
      response.should be_success
    end
  
  end
  
end
