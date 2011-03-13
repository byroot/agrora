shared_examples_for 'top_level_node' do
  
  it { should have_fields(:updated_at).of_type(Time) }
  it { should have_fields(:groups).of_type(Array) }
  
  it { should validate_length_of(:groups) }
  
end