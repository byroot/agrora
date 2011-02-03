class Server
  include Mongoid::Document
  
  index :hostname, :unique => true
  
  field :hostname, :type => String
  field :port, :type => Integer, :default => 119
  field :user, :type => String
  field :secret, :type => String
  
  validates_presence_of :hostname
  validates_uniqueness_of :hostname
  validates_numericality_of :port, :only_integer => true, :greater_than => 0, :less_than => 2 ** 16
  references_many :groups
  before_validation :clean_user_and_secret
  
  def to_param
    hostname
  end

  def clean_user_and_secret
    self.user = nil if self.user.blank?
    self.secret = nil if self.secret.blank?
  end
  
end
