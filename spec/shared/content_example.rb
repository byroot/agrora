shared_examples_for 'content' do
  
  it { should have_fields(:subject).of_type(String) }
  it { should have_fields(:body).of_type(String) }
  it { should have_fields(:created_at).of_type(DateTime) }
  it { should have_fields(:author_name).of_type(String) }
  it { should have_fields(:author_email).of_type(String) }
  
  it { should validate_presence_of(:subject) }
  it { should validate_presence_of(:body) }
  it { should validate_presence_of(:created_at) }
  it { should validate_presence_of(:author_email) }
  
  describe '.new' do
    
    subject do
      @klass.new
    end
    
    its(:created_at) { should be_present }
    its(:created_at) { should be_a(DateTime) }
    
    it 'should have a random default message_id' do
      expect{
        @klass.new.message_id
      }.to be_random
    end
    
  end
  
end
