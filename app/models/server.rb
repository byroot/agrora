class Server
  include Mongoid::Document
  
  field :hostname, :type => String
  field :port, :type => Integer, :default => 119
  field :user, :type => String
  field :secret, :type => String
  
  validates_presence_of :hostname
  validates_uniqueness_of :hostname
  
  references_many :groups
  
end
