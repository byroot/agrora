require 'spec_helper'

describe User do

  subject do
    Fabricate(:user)
  end
  
  it_should_behave_like 'authorized'
  
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
    
    it { should_not be_authorized_to(:create_message) }

    it { should_not be_authorized_to(:view_admin) }
    
    it 'should have a random salt' do
      expect{
        User.new.password_salt
      }.to be_random
    end
    
  end
  
  describe 'after_create' do
    
    subject do
      Fabricate(:user)
    end
    
    its(:activation_token) { should be_present }
    
  end
  
  describe '#make_activation_token' do
    
    subject do
      Fabricate.build(:user)
    end
    
    it 'should store an activation_token' do
      expect{
        subject.save
      }.to change{ subject.activation_token }.from(nil).to(instance_of(String))
      subject.activation_token.should match(/[\w\d]{32,}/)
    end
    
    it 'should be random' do
      subject.save!
      expect{
        subject.send(:make_activation_token)
        subject.activation_token
      }.to be_random
    end
    
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
    
    it 'should authorize user to create message' do
      expect{
        subject.activate!
      }.to change{ subject.authorized_to?(:create_message) }.from(false).to(true)
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
  
  describe "#admin?" do
    
    it 'should authorize user to view admin interface' do
      subject.activate!
      expect{
        subject.update_attributes(:admin => true)
      }.to change{ subject.authorized_to?(:view_admin) }.from(false).to(true)
    end
    
  end
  
end
