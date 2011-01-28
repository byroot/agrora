module Node
  
  def self.included(base)
    base.embeds_many :responses, :class_name => 'Message'
  end
  
  def responses_hash
    @responses_hash ||= responses.index_by(&:message_id)
  end
  
  attr_writer :references
  def references
    @references ||= ancestors.map(&:message_id)
  end
  
  def root
    references.first
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