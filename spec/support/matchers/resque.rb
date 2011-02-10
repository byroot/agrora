RSpec::Matchers.define :trigger do |job_class|
  
  match do |block|
    expected_job = {'class' => job_class.name, 'args' => @arguments}
    !triggered?(expected_job) && (block.call || true) && triggered?(expected_job)
  end
  
  def triggered?(job)
    Resque.peek(@queue, 0, 50).include?(job)
  end
  
  chain :with do |*arguments|
    @arguments = arguments
  end
  
  chain :in do |queue|
    @queue = queue
  end
  
end
