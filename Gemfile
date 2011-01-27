source 'http://rubygems.org'

gem 'rails', '3.0.3'

# MongoDB
gem "mongoid", "2.0.0.beta.20"
gem "bson_ext", "1.1.5"

# Redis
gem "resque", '1.10.0'
gem "resque-lock", "0.1.1"
gem "redis-objects", :git => 'http://github.com/byroot/redis-objects.git'

# NNTP
gem "mail", :git => 'http://github.com/byroot/mail.git'

group :test do
  gem "rspec-rails", "~> 2.4"
  gem 'mongoid-rspec', '1.3.2'
  gem 'fabrication', '0.9.4'
  gem 'rcov'
end

group :development do
  gem 'ruby-debug19'
  gem "rspec-rails", "~> 2.4" # for rake rspec
end
