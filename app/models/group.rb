class Group
  include Mongoid::Document
  
  field :name, :type => String
  field :last_synchronisation_at, :type => DateTime, :default => DateTime.new(1970)
  references_and_referenced_in_many :servers
  
  index :name, :unique => true
  
  validates_presence_of :name
  validates_format_of :name, :with => /[az\.]+/
  
  def to_param
    name
  end
  
  def topics
    RootNode.in_group(self)
  end
  
end
