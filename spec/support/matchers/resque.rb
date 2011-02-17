RSpec::Matchers.define :trigger do |job_class|
  
  match do |block|
    @job_class = job_class
    initial = queue_content
    block.call
    change = queue_content - initial
    change.include?(expected_job)
  end
  
  def expected_job
    @arguments ? {'class' => @job_class.name, 'args' => @arguments} : hash_including('class' => @job_class.name)
  end
  
  def queue_content
    Resque.peek(@job_class.instance_variable_get('@queue'), 0, 50)
  end
  
  chain :with do |*arguments|
    @arguments = arguments
  end
  
end
