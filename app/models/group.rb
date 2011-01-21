class Group
  include Mongoid::Document
  
  field :name, :type => String
  field :server, :type => Server
  field :last_synchronisation_at, :type => DateTime, :default => DateTime.new(1970)
  referenced_in :server
  
  validates_presence_of :server, :name
  validates_format_of :name, :with => /[az\.]+/
  
  def to_param
    name
  end
  
  def topics
    Topic.in_group(self)
  end
  
end
