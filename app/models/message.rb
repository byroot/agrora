class Message

  include Mongoid::Document
  
  field :author_name, :type => String
  field :author_email, :type => String
  field :message_id, :type => String
  field :subject, :type => String
  field :body, :type => String
  field :created_at, :type => DateTime
  
  recursively_embeds_many
  
  validates_presence_of :message_id, :subject, :body, :created_at, :author_email
  
  before_validation :set_created_at, :set_message_id
  
  attr_writer :references
  def references
    @references ||= ancestors.map(&:message_id)
  end
  
  def root
    references.first
  end
  
  def child_messages_hash
    @child_messages_hash ||= child_messages.index_by(&:message_id)
  end
  
  def indexes
    @indexes ||= (ancestors + [self]).map(&:index)
  end
  
  alias :index :_index
  
  protected
  
  def set_created_at
    self.created_at ||= DateTime.now.utc
  end
  
  def set_message_id
    self.message_id ||= "#{ActiveSupport::SecureRandom.hex}@agrora.#{Rails.env}" # TODO: allow to configure hostname
  end
  
  private
  
  def ancestors
    [].tap do |path|
      cursor = parent_message
      while cursor
        path << cursor
        cursor = cursor.parent_message
      end
    end.reverse
  end
  
  def to_param
    index.to_s
  end
  
end