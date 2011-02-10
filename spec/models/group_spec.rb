require 'spec_helper'

describe Group do
  
  subject do
    Fabricate(:group)
  end
  
  before :each do
    @server = Fabricate(:server)
  end
  
  it { should have_fields(:name).of_type(String) }
  
  it { should validate_presence_of(:name) }
  
  it { should reference_and_be_referenced_in_many(:servers) }
  
  it 'should validate format of name' do
    @server.groups.create(:name => '42').should have(1).error_on(:name)
    @server.groups.create(:name => 'os.comp.foo').should be_persisted
  end
  
end
