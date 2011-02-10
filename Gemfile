source 'http://rubygems.org'

gem 'rails', '3.0.3'

# MongoDB
gem "mongoid", "2.0.0.rc.7"
gem "bson_ext", "1.2.0"

# Redis
gem "resque", '1.10.0'
gem "resque-lock", "0.1.1"
gem "redis-objects", :git => 'http://github.com/byroot/redis-objects.git'

# NNTP
gem "mail", :git => 'http://github.com/byroot/mail.git'

group :test do
  gem "rspec-rails", "~> 2.4"
  gem 'mongoid-rspec', :git => 'http://github.com/durran/mongoid-rspec.git'
  gem 'fabrication', '0.9.4'
  gem 'rcov'
end

group :development do
  gem 'ruby-debug19'
  gem "rspec-rails", "~> 2.4" # for rake rspec
end
