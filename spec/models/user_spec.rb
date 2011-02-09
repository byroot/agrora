require 'spec_helper'

describe User do

  subject do
    Fabricate(:user)
  end

  it{ should have_field(:email).of_type(String) }
  it{ should have_field(:username).of_type(String) }
  it{ should have_field(:password_hash).of_type(String) }
  it{ should have_field(:password_salt).of_type(String) }
  it{ should have_field(:activation_token).of_type(String) }
  it{ should have_field(:is_admin?).of_type(Boolean) }
  it{ should have_field(:state).of_type(Boolean) }

  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:password_hash) }
  it { should validate_presence_of(:password_salt) }
  it { should validate_presence_of(:username) }
  it { should validate_uniqueness_of(:email) }
  it { should validate_format_of(:email) }

  it 'should have nil as token by default' do
    User.new.activation_token.should == nil
  end

  it 'should\'nt be admin by default' do
    User.new.is_admin?.should == false
  end

  it 'should\'nt be active by default' do
    User.new.active?.should == false
  end

  describe "#authentificate" do
    it "should return nil if no user match" do
      User.authenticate("nobody@somewhere.com", "something") == nil
    end

    it "should return the user if email and password match" do
      #user is activate? in theory no
      User.authenticate("test@example.com", "azerty") == User.find(:first, :conditions => {:email => "test@example.com"})
    end
    
    it "should'nt authenticate the user if the password is wrong" do
      User.authenticate("test@example.com", "something") == nil
    end
  end

end
