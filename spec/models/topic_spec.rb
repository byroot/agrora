require 'spec_helper'

describe Topic do
  
  subject{ Fabricate(:topic) }
  
  it { should have_fields(:created_at).of_type(Time) }
  it { should have_fields(:updated_at).of_type(Time) }
  it { should have_fields(:groups).of_type(Array) }
  
  it { should embed_one :message }
  it { should validate_presence_of(:message) }
  it { should validate_length_of(:groups) }
  
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
  
  describe '#insert_or_update_message' do
    
    it 'should insert new messages' do
      @message = Fabricate.build(:message,
        :parent => subject.message,
        :message_id => 'unused@troll.com'
      )
      
      expect{
        subject.insert_or_update_message(@message)
      }.to change{
        subject.reload.message.responses.count
      }.by(1)
    end
    
    it 'should update existing message' do
      @old_message = subject.message.responses.first
      @message = Fabricate.build(:message,
        :parent => subject.message,
        :message_id => @old_message.message_id,
        :body => 'CENSORED'
      )
      
      expect{
        expect{
          subject.insert_or_update_message(@message)
        }.to change{ subject.reload.message.responses.first.body }
      }.to_not change{
        subject.reload.message.responses.count
      }.by(1)
    end
    
  end
  
  describe "#find_message_by_references" do
    
    it 'can find a message from any depth' do
      @references = %w(34567@troll.com 23456@troll.com 12345@troll.com)
      subject.find_message_by_references(@references).message_id.should == '34567@troll.com'
    end
    
    it 'should return nil if references are invalid' do
      @references = %w(23456@troll.com 34567@troll.come foo)
      subject.find_message_by_references(@references).should be_nil
    end
    
  end
  
end
