class Group
  include Mongoid::Document
  
  field :name, :type => String
  field :server, :type => Server
  
  referenced_in :server
  
  validates_presence_of :server, :name
  
end
