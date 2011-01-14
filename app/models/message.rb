class Message

  include Mongoid::Document
  include Node
  
  field :message_id, :type => String
  field :subject, :type => String
  field :body, :type => String
  field :created_at, :type => DateTime

  embedded_in :parent, :inverse_of => :responses
  
  validates_presence_of :message_id, :subject, :body, :created_at
    
end