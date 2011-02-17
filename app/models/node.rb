class Node
  
  include Mongoid::Document
  include Mongoid::Mutation
  
  self.collection_name = 'messages'
  
  field :message_id, :type => String
  
  recursively_embeds_many
  
  validates_presence_of :message_id
  
  index :index, :unique => true
  
  # Temporary legacy
  alias_method :child_messages, :child_nodes
  alias_method :parent_message, :parent_node
  
  attr_writer :references
  def references
    @references ||= ancestors.map(&:message_id)
  end
  
  def root
    _root.message_id
  end
  
  def index
    read_attribute(:index) || _index
  end
  
  def child_messages_hash
    @child_messages_hash ||= child_messages.index_by(&:message_id)
  end
  
  def indexes
    @indexes ||= (ancestors + [self]).map(&:index)
  end
  
  protected
  
  def ancestors
    [].tap do |path|
      cursor = parent_node
      while cursor
        path << cursor
        cursor = cursor.parent_node
      end
    end.reverse
  end
  
end