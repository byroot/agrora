shared_examples_for 'authorized' do
  
  it { should respond_to(:authorized_to?) }
  
end