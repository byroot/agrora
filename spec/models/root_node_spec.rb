require 'spec_helper'

describe RootNode do
  
  it_should_behave_like 'node', 'top_level_node'
  
  before :each do
    @root_node = Fabricate(:root_node)
  end
  
  subject{ @root_node }
  
  its(:subject) { should == "Re: Ruby sucks !" }
  
end
