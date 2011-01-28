class Topic
  
  include Mongoid::Document
  include Mongoid::Timestamps
  
  include Node
  
  field :groups, :type => Array
  field :root, :type => String
  field :index, :type => Integer
  
  validates_presence_of :root, :index
  validates_length_of :groups, :minimum => 1
  
  before_validation :set_root, :set_index
  
  index :root, :unique => true
  index :index, :unique => true
  
  delegate :subject, :to => 'responses.first'
  
  scope :in_group, lambda{ |group| where(:groups => group.is_a?(Group) ? group.name : group) }
  
  class << self
    
    def index_counter
      @index_counter ||= Redis::Counter.new('topic_index_counter')
    end
    
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
  
  def find_message_by_indexes(indexes)
    cursor = self
    indexes.each do |index|
      cursor = cursor.responses[index] or return
    end
    cursor
  end
  
  def find_message_by_references(references)
    return unless references.first == self.root
    cursor = self
    references.each do |reference|
      cursor = cursor.responses_hash[reference] || cursor
    end
    cursor
  end
  
  def to_param
    index.to_s
  end
  
  protected
  
  def set_root
    self.root ||= responses.first.message_id if responses.any?
  end
  
  def set_index
    self.index ||= self.class.index_counter.increment
  end
  
end