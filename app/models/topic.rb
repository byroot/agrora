class Topic
  
  include Mongoid::Document
  include Mongoid::Timestamps
  include Node
  
  field :groups, :type => Array
  field :root, :type => String
  
  validates_presence_of :root
  validates_length_of :groups, :minimum => 1
  
  before_validation :set_root
  
  class << self
    
    def create_from_message!(message, groups)
      create!(:responses => [message], :root => message.root, :groups => groups)
    end
    
  end
  
  def insert_or_update_message(message)
    parent = find_message_by_references(message.references)
    if old_message = parent.responses_hash[message.message_id] # update
      old_message.update_attributes!(message.attributes.except(:_id))
    else
      parent.responses << message
      if message.save
        parent.responses_hash[message.message_id] = message
      end
    end
  end
  
  def find_message_by_references(references)
    return unless references.last == self.root
    cursor = self
    references.reverse.each do |reference|
      cursor = cursor.responses_hash[reference] || cursor
    end
    cursor
  end
  
  protected
  
  def set_root
    self.root ||= responses.first.message_id if responses.any?
  end
  
end