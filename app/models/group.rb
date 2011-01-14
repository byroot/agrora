class Group
  include Mongoid::Document
  
  field :name, :type => String
  field :server, :type => Server
  field :last_synchronisation_at, :type => DateTime, :default => DateTime.new(1970)
  referenced_in :server
  
  validates_presence_of :server, :name
  
end
