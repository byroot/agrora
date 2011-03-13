require 'spec_helper'

describe RootNode do
  
  it_should_behave_like 'top_level_node'
  
  before :each do
    @root_node = Fabricate(:root_node)
  end
  
  subject{ @root_node }
  
  it { should have_fields(:created_at).of_type(Time) }
  
  it { should embed_many :child_nodes }
  
  its(:subject) { should == "Re: Ruby sucks !" }
  
end
