RSpec::Matchers.define :ends_with do |expected|
  
  match do |actual|
    actual.ends_with? expected
  end
  
end

RSpec::Matchers.define :starts_with do |expected|
  
  match do |actual|
    actual.starts_with? expected
  end
  
end
