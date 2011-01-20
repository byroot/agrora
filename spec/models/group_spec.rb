require 'spec_helper'

describe Group do
  
  subject do
    Fabricate(:group)
  end
  
  it { should have_fields(:name).of_type(String) }
  
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:server) }
  
  it 'should validate format of name' do
    subject.server.groups.create(:name => '42').should have(1).error_on(:name)
    subject.server.groups.create(:name => 'os.comp.foo').should be_persisted
  end
  
end
