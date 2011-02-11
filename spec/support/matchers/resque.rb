RSpec::Matchers.define :trigger do |job_class|
  
  match do |block|
    @job_class = job_class
    !triggered? && (block.call || true) && triggered?
  end
  
  def triggered?
    expected_job = @arguments ? {'class' => @job_class.name, 'args' => @arguments} : hash_including('class' => @job_class.name)
    Resque.peek(@job_class.instance_variable_get('@queue'), 0, 50).any? do |job|
      expected_job == job
    end
  end
  
  chain :with do |*arguments|
    @arguments = arguments
  end
  
end
