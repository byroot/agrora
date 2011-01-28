module Node
  
  def self.included(base)
    base.embeds_many :responses, :class_name => 'Message'
  end
  
  def responses_hash
    @responses_hash ||= responses.index_by(&:message_id)
  end
  
  def index
    parent.responses.index(self)
  end
  
  def indexes
    @indexes ||= ancestors.map(&:index) + [self.index]
  end
  
  attr_writer :references
  def references
    @references ||= ancestors.map(&:message_id)
  end
  
  def root
    references.first
  end
  
  def parent
  end
  
  private
  
  def ancestors
    [].tap do |path|
      cursor = parent
      while cursor.is_a?(Message)
        path << cursor
        cursor = cursor.parent
      end
    end.reverse
  end
  
end