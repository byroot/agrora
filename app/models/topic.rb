class Topic
  
  include Mongoid::Document
  include Mongoid::Timestamps
  
  field :groups, :type => Array
  
  embeds_one :message
  
  validates_presence_of :message
  validates_length_of :groups, :minimum => 1
  
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
    return unless references.last == message.message_id
    cursor = message
    references.reverse[1..-1].each do |reference|
      return unless cursor = cursor.responses_hash[reference]
    end
    cursor
  end
  
end