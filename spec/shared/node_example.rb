shared_examples_for 'node' do
  
  it { should have_fields(:message_id).of_type(String) }
  
  it { should validate_presence_of(:message_id) }
  
  it { should have_fields(:created_at) }
  
  it { should embed_many :child_nodes }
  
end