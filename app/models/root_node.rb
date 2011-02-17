class RootNode < Node
  
  include Mongoid::Timestamps
  
  field :groups, :type => Array
  field :index, :type => Integer
  
  validates_presence_of :index
  validates_length_of :groups, :minimum => 1
  
  before_validation :set_index
  
  class << self
    
    def in_group(group)
      where(:groups => group.is_a?(Group) ? group.name : group)
    end
    
    def index_counter
      @index_counter ||= Redis::Counter.new('topic_index_counter')
    end
    
  end
  
  def subject
    walk{ |node| return node.subject if node.is_a?(Message) }
    'unkown'
  end
  
  def to_param
    "#{index}-#{subject}".parameterize
  end
  
  def insert_or_update_message(message)
    parent = find_message_by_references(message.references)
    if old_message = parent.child_messages_hash[message.message_id] # update
      old_message.update_attributes!(message.attributes.except(:_id))
    else
      parent.child_messages << message
      if message.save
        parent.child_messages_hash[message.message_id] = message
      end
    end
  end
  
  def find_message_by_indexes(indexes)
    return unless indexes.first == self.index
    cursor = self
    indexes[1..-1].each do |index|
      cursor = cursor.child_messages[index] or return
    end
    cursor
  end
  
  def find_message_by_references(references)
    return unless references.first == self.root
    cursor = self
    references.each do |reference|
      cursor = cursor.child_messages_hash[reference] || cursor
    end
    cursor
  end
  
  protected
  
  def set_index
    self.index ||= self.class.index_counter.increment unless parent_node
  end
  
end