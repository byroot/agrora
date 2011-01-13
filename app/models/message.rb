class Message

  include Mongoid::Document
  
  field :message_id, :type => String
  field :subject, :type => String
  field :body, :type => String
  field :created_at, :type => DateTime
  
  validates_presence_of :message_id, :subject, :body, :created_at
  
  embeds_many :responses, :class_name => 'Message'
  embedded_in :parent, :inverse_of => :responses
  
  def responses_hash
    @responses_hash ||= Hash[responses.map{ |r| [r.message_id, r] }]
  end
  
  attr_writer :references
  def references
    @references ||= ancestors.map(&:message_id)
  end
  
  private
  
  def ancestors
    [].tap do |path|
      cursor = parent
      while cursor.is_a?(Message)
        path << cursor
        cursor = cursor.parent
      end
    end
  end
  
end