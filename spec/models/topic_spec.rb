require 'spec_helper'

describe Topic do
  
  before :all do
    @klass = Topic
  end
  
  it_should_behave_like 'node', 'content', 'top_level_node'
  
  subject{ Fabricate(:topic) }
  
  describe 'belongs to groups' do
    
    it 'can have multiple groups' do
      @topic = Fabricate.build(:topic, :groups => %w(comp.lang.ruby comp.lang.c))
      @topic.save.should be_true
    end
    
    it 'can be found into each of its groups' do
      expect{
        expect{
          Fabricate.build(:topic, :groups => %w(comp.lang.ruby comp.lang.c)).save!
        }.to change{ Topic.where(:groups => 'comp.lang.ruby').count }.by(1)
      }.to change{ Topic.where(:groups => 'comp.lang.c').count }.by(1)
    end
    
  end
  
  describe '#index' do
    
    it 'should be incremented before each topic creation' do
      expect{
        Fabricate(:topic)
      }.to change{ Topic.index_counter.value }.by(1)
    end
    
    it 'should not be incremented on update' do
      @topic = Fabricate(:topic)
      expect{
        @topic.update_attributes!(:message_id => 'foo')
      }.to_not change{ Topic.index_counter.value }
    end
    
  end
  
  describe '#insert_or_update_message' do
    
    it 'should insert new messages' do
      @parent = subject
      @message = Fabricate.build(:message,
        :references => %w(12345@troll.com),
        :message_id => 'unused@troll.com'
      )

      expect{
        subject.insert_or_update_message(@message)
      }.to change{
        subject.reload.child_messages.count
      }.by(1)
    end
    
    it 'should update existing message' do
      @old_message = subject.child_messages.first.child_messages.first
      @message = Fabricate.build(:message,
        :references => %w(12345@troll.com 23456@troll.com),
        :message_id => @old_message.message_id,
        :body => 'CENSORED'
      )
      
      expect{
        expect{
          subject.insert_or_update_message(@message)
        }.to change{ subject.reload.child_messages.first.child_messages.first.body }
      }.to_not change{
        subject.reload.child_messages.first.child_messages.count
      }.by(1)
    end
    
  end
  
  describe "#find_message_by_references" do
    
    it 'can find a message from any depth' do
      @references = %w(12345@troll.com 23456@troll.com 34567@troll.com)
      subject.find_message_by_references(@references).should be_present
      subject.find_message_by_references(@references).message_id.should == '34567@troll.com'
    end
    
    it 'should return nil if references are invalid' do
      @references = %w(foo 23456@troll.com 34567@troll.come)
      subject.find_message_by_references(@references).should be_nil
    end
    
    it 'should skip missing references' do
      @references = %w(missing missing_again 23456@troll.com 34567@troll.com)
      subject.update_attributes(:message_id => 'missing')
      subject.find_message_by_references(@references).should be_present
      subject.find_message_by_references(@references).message_id.should == '34567@troll.com'
    end
    
  end
  
  describe '#find_message_by_indexes' do
    
    it 'can find a message from any depth' do
      @indexes = [1, 0, 0]
      subject.find_message_by_indexes(@indexes).message_id.should == '34567@troll.com'
    end
    
    it 'should return nil if indexes are invalid' do
      @indexes = [12, 32, 54]
      subject.find_message_by_indexes(@indexes).should be_nil
    end
    
    it 'should not skip missing indexes' do
      @indexes = [0, 12, 0]
      subject.find_message_by_indexes(@indexes).should be_nil
    end
    
  end
  
end
