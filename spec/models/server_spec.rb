require 'spec_helper'

describe Server do
  
  it { should have_fields(:hostname).of_type(String) }
  it { should have_fields(:port).of_type(Integer) }
  it { should have_fields(:user).of_type(String) }
  it { should have_fields(:secret).of_type(String) }
  
  it { should validate_presence_of(:hostname) }
  
  it 'should use 119 as default port' do
    Server.new.port.should == 119
  end
  
end
