require 'spec_helper'

describe User do
  it{ should have_field(:email).of_type(String) }
  it{ should have_field(:username).of_type(String) }
  it{ should have_field(:password_hash).of_type(String) }
  it{ should have_field(:password_salt).of_type(String) }
  it{ should have_field(:token).of_type(String) }
  it{ should have_field(:is_admin?).of_type(Boolean) }

  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:password_hash) }
  it { should validate_presence_of(:password_salt) }
  it { should validate_presence_of(:username) }
  it { should validate_uniqueness_of(:email) }
  it { should validate_format_of(:email) }

  it 'should have nil as token by default' do
    User.new.token.should == nil
  end

  it 'should\'nt be admin by default' do
    User.new.is_admin?.should == false
  end

end
