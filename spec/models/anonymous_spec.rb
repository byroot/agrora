require 'spec_helper'

describe Anonymous do
  
  it_should_behave_like 'authorized'
  
  it { should_not be_activated }
  
  it { should_not be_admin }
  
  it { should_not be_authorized_to(:create_message) }
  
  it { should_not be_authorized_to(:view_admin) }
  
end