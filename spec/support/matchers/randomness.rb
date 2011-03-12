RSpec::Matchers.define :be_random do
  
  match do |block|
    set = Set.new
    !!1000.times do
      value = block.call
      break if set.include?(value)
      set << value
    end
  end
  
end
