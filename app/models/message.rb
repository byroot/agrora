class Message

  include Mongoid::Document
  include Node
  
  field :author_name, :type => String
  field :author_email, :type => String
  field :message_id, :type => String
  field :subject, :type => String
  field :body, :type => String
  field :created_at, :type => DateTime

  embedded_in :parent, :inverse_of => :responses
  
  validates_presence_of :message_id, :subject, :body, :created_at, :author_email
    
end