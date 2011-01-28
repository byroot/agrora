require 'spec_helper'

describe Message do
  
  subject do
    @topic = Fabricate(:topic)
    @references = %w(12345@troll.com 23456@troll.com 34567@troll.com)
    @message = @topic.find_message_by_references(@references)
  end
  
  it { should have_fields(:message_id).of_type(String) }
  it { should have_fields(:subject).of_type(String) }
  it { should have_fields(:body).of_type(String) }
  it { should have_fields(:created_at).of_type(DateTime) }
  it { should have_fields(:author_name).of_type(String) }
  it { should have_fields(:author_email).of_type(String) }
  
  it { should validate_presence_of(:message_id) }
  it { should validate_presence_of(:subject) }
  it { should validate_presence_of(:body) }
  it { should validate_presence_of(:created_at) }
  it { should validate_presence_of(:author_email) }
  
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
      subject.indexes.should == [0, 0]
    end
    
  end
  
end
