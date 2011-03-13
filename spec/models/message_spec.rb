require 'spec_helper'

describe Message do
  
  before :all do
    @klass = Message # TODO: find a better pattern
  end
  
  it_should_behave_like 'content'
  
  before :each do
    @topic = Fabricate(:topic)
    @references = %w(12345@troll.com 23456@troll.com 34567@troll.com)
  end
  
  subject do
    @message = @topic.find_message_by_references(@references)
  end
  
  it { should have_fields(:message_id).of_type(String) }
  
  it { should validate_presence_of(:message_id) }
  
  describe '#references' do
    
    it 'should rebuild references' do
      subject.references.should == @references[0..-2]
    end
    
    it 'should use references provided throught build if any' do
      Message.new(:references => 'foo').references.should == 'foo'
    end
    
  end
  
  describe '#indexes' do
    
    it 'should build index array based on messages positions' do
      subject.indexes.should == [1, 0, 0]
    end
    
    it 'should be consistent' do
      @topic.find_message_by_indexes(subject.indexes).should == subject
    end
    
  end
  
end
