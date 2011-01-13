require 'spec_helper'

describe Message do
  
  subject do
    @topic = Fabricate(:topic)
    @references = %w(34567@troll.com 23456@troll.com 12345@troll.com)
    @message = @topic.find_message_by_references(@references)
  end
  
  describe '#references' do
    
    it 'should rebuild references' do
      subject.references.should == @references[1..-1]
    end
    
    it 'should use references provided throught build if any' do
      Message.new(:references => 'foo').references.should == 'foo'
    end
    
  end
  
end
