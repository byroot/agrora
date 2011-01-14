require 'spec_helper'

describe Group do
  
  subject do
    Fabricate(:group)
  end
  
  it { should have_fields(:name).of_type(String) }
  
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:server) }
  
end
