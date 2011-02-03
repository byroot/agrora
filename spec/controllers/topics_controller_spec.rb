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
    
    it 'should paginate topics'
    
    it 'should trigger an UpdateGroup job if necessary' do
      expect{
        get :index, :group_id => 'comp.lang.ruby'
      }.to change{ Resque.peek('nntp') }.from(nil).to({"class"=>"Jobs::UpdateGroup", "args"=>["comp.lang.ruby"]})
    end

    it 'should not trigger an UpdateGroup job if it is not necessary' do
      @group.update_attributes!(:last_synchronisation_at => DateTime.now)
      expect{
        get :index, :group_id => 'comp.lang.ruby'
      }.to_not change{ Resque.peek('nntp') }
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
    
    it 'should raise DocumentNotFound if topic does not exist' do
      expect{
        get :show, :group_id => 'comp.lang.ruby', :id => '42'
      }.to raise_error(Mongoid::Errors::DocumentNotFound)
    end
    
    it 'should trigger an UpdateGroup job' do
      expect{
        get :show, :group_id => 'comp.lang.ruby', :id => Topic.first.index.to_s
      }.to change{ Resque.peek('nntp') }.from(nil).to({"class"=>"Jobs::UpdateGroup", "args"=>["comp.lang.ruby"]})
    end
    
    it 'should not trigger an UpdateGroup job if it is not necessary' do
      @group.update_attributes!(:last_synchronisation_at => DateTime.now)
      expect{
        get :show, :group_id => 'comp.lang.ruby', :id => Topic.first.index.to_s
      }.to_not change{ Resque.peek('nntp') }
    end
    
  end
  
end