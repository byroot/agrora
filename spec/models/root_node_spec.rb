require 'spec_helper'

describe RootNode do
  
  before :each do
    @root_node = Fabricate(:root_node)
  end
  
  subject{ @root_node }
  
  it { should have_fields(:groups).of_type(Array) }
  
  it { should have_fields(:created_at).of_type(Time) }
  
  it { should have_fields(:updated_at).of_type(Time) }
  
  it { should embed_many :child_nodes }
  
  it { should validate_length_of(:groups) }
  
  its(:subject) { should == "Re: Ruby sucks !" }
  
end
