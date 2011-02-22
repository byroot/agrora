require 'spec_helper'

describe User do

  subject do
    Fabricate(:user)
  end
  
  it{ should have_field(:email).of_type(String) }
  it{ should have_field(:username).of_type(String) }
  it{ should have_field(:password_hash).of_type(String) }
  it{ should have_field(:password_salt).of_type(String) }
  it{ should have_field(:is_admin).of_type(Boolean) }
  it{ should have_field(:state).of_type(String) }

  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:password_hash) }
  it { should validate_presence_of(:password_salt) }
  it { should validate_presence_of(:username) }
  it { should validate_uniqueness_of(:email) }
  it { should validate_format_of(:email) }

  describe '.new' do
    
    subject do
      User.new
    end
    
    its(:activation_token) { should be_nil }
    
    it { should_not be_admin }
    
    it { should_not be_activated }
    
    it { should be_disabled }
    
  end
  
  describe '#activate!' do
    
    it 'should activate disabled users' do
      expect{
        subject.activate!
      }.to change{ subject.activated? }.from(false).to(true)
    end
    
    it 'should destroy activation token' do
      expect{
        subject.activate!
      }.to change{ subject.activation_token }.to(nil)
    end
    
    it 'should raise activated users' do
      subject.activate!
      expect{
        subject.activate!
      }.to raise_error
    end
    
  end
  
  describe ".authenticate" do

    it "should return nil if no user match" do
      User.authenticate("nobody@somewhere.com", "something").should be_nil
    end

    it "should return the user if email and password match" do
      subject.activate!
      User.authenticate("test@example.com", "azerty").should == subject
    end
    
    it 'should not authenticate unactivated users' do
      User.authenticate("test@example.com", "azerty").should be_nil
    end
    
    it "should'nt authenticate the user if the password is wrong" do
      User.authenticate("test@example.com", "something").should be_nil
    end
  end

end
