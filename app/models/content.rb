module Content
  
  def self.included(base)
    base.field :author_name, :type => String
    base.field :author_email, :type => String
    base.field :subject, :type => String
    base.field :body, :type => String
    base.field :created_at, :type => DateTime
    
    base.validates_presence_of :subject, :body, :created_at, :author_email

    base.before_validation :set_created_at, :set_message_id
  end
  
  def author=(user)
    self.author_name = user.username
    self.author_email = user.email
  end
  
  protected
  
  def set_created_at
    self.created_at ||= DateTime.now.utc
  end
  
  def set_message_id
    self.message_id ||= "#{ActiveSupport::SecureRandom.hex}@agrora.#{Rails.env}" # TODO: allow to configure hostname
  end
  
end