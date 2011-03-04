require 'spec_helper'

describe Jobs::UpdateGroup do
  
  before :each do
    @group = Fabricate(:group)
    @worker = Jobs::UpdateGroup.new('comp.lang.ruby')
    @worker.stub!(:server => [])
  end

  subject{ @worker }
  
  describe '#store!' do
    
    it 'should store message without any references as Topic' do
      @message = Fabricate.build(:message, :groups => %w(comp.lang.ruby))
      expect{
        subject.store!(@message)
      }.to change{ Topic.where(:message_id => @message.message_id).count }.by(1)
    end
    
    it 'should create RootNode if it does not exist yet' do
      @message = Fabricate.build(:message, :references => %w(root_node@foo.com), :groups => %w(comp.lang.ruby))
      expect{
        subject.store!(@message)
      }.to change{ RootNode.where(:message_id => 'root_node@foo.com').count }.by(1)
    end
    
    it 'should update existing RootNode to plain Topic' do
      subject.store! Fabricate.build(:message, :references => %w(root_node@foo.com), :groups => %w(comp.lang.ruby))
      
      @message = Fabricate.build(:message, :message_id => 'root_node@foo.com', :groups => %w(comp.lang.ruby))
      expect{
        subject.store!(@message)
      }.to change{ RootNode.where(:message_id => 'root_node@foo.com').first.class }.from(RootNode).to(Topic)
    end
    
    it 'should update existing Node to plain Message' do
      @node = Proc.new{ RootNode.where(:message_id => 'root_node@foo.com').first.child_nodes.first }
      subject.store! Fabricate.build(:message, :references => %w(root_node@foo.com some_message@bar.com), :groups => %w(comp.lang.ruby))
      
      @message = Fabricate.build(:message, :message_id => 'some_message@bar.com', :references => %w(root_node@foo.com), :groups => %w(comp.lang.ruby))
      expect{
        expect{
          subject.store!(@message)
        }.to change{ @node.call.class }.from(Node).to(Message)
      }.to_not change{ @node.call.child_nodes.count }
    end
    
  end
  
end
