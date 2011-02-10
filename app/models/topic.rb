class Topic < Message
  
  include Mongoid::Timestamps
  
  field :groups, :type => Array
  field :index, :type => Integer
  field :root, :type => String
  
  validates_presence_of :index
  validates_length_of :groups, :minimum => 1
  
  before_validation :set_index, :set_root
  
  index :message_id, :unique => true
  index :index, :unique => true
  
  scope :in_group, lambda{ |group| where(:groups => group.is_a?(Group) ? group.name : group) }
  
  class << self
    
    def index_counter
      @index_counter ||= Redis::Counter.new('topic_index_counter')
    end
    
    def create_from_message!(message, groups)
      create!(:child_messages => [message], :root => message.root, :groups => groups)
    end
    
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
    cursor = self
    indexes.each do |index|
      cursor = cursor.child_messages[index] or return
    end
    cursor
  end
  
  def find_message_by_references(references)
    return unless references.first == self.message_id
    cursor = self
    references.each do |reference|
      cursor = cursor.child_messages_hash[reference] || cursor
    end
    cursor
  end
  
  def to_param
    index.to_s
  end
  
  protected
  
  def set_root
    self.root ||= self.message_id
  end
  
  def set_index
    self.index ||= self.class.index_counter.increment
  end
  
end