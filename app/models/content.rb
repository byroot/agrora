module Content
  
  def self.included(base)
    base.field :author_name, :type => String
    base.field :author_email, :type => String
    base.field :subject, :type => String
    base.field :body, :type => String
    base.field :created_at, :type => DateTime, :default => Proc.new{ DateTime.now.utc }
    
    base.validates_presence_of :subject, :body, :created_at, :author_email
  end
  
  def author=(user)
    self.author_name = user.username
    self.author_email = user.email
  end
  
end
