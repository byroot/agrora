class User
  include Mongoid::Document
  include Mongoid::Timestamps
  include Stateflow
  
  include Redis::Objects
  
  include Authorization::ModelMixin
  
  value :token

  index :email, :unique => true
  
  attr_accessor :password, :password_confirmation

  attr_protected :password_hash, :password_salt

  before_create :make_activation_token

  field :email, :type => String
  field :username, :type => String
  field :password_hash, :type => String
  field :password_salt, :type => String, :default => Proc.new{ ActiveSupport::SecureRandom.hex }
  field :is_admin, :type => Boolean, :default => false
  field :state, :type => String
  
  validates_presence_of :email, :username, :password_hash, :password_salt
  validates_uniqueness_of :email
  validates_format_of :email, :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i
  validate :check_password
  
  alias_method :admin=, :is_admin=
  alias_method :admin?, :is_admin
  
  delegate :encrypt_password, :to => 'self.class'
  
  stateflow do
    state_column :state
    initial :disabled

    state :disabled
    state :activated do
      enter lambda { |user| user.clear_activation_token }
    end

    event :activate do
      transitions :from => :disabled, :to => :activated
    end

  end
  
  def password=(password)
    @password = password
    self.password_hash = encrypt_password(password, password_salt)
  end
  
  def activation_token
    self.token.value
  end

  def activation_token=(value)
    self.token.value = value
  end

  def clear_activation_token
    self.token.delete
  end

  def to_param
    email
  end
  
  class << self
    
    def authenticate(login, pass)
      user = first(:conditions => {:email => login, :state => 'activated'})
      user if user && user.password_hash == encrypt_password(pass, user.password_salt)
    end

    def activate(user_id, activation_token)
      user = User.find(user_id)
      if user && user.activation_token == activation_token
        user.tap(&:activate!)
      end
    end
    
    def encrypt_password(password, salt)
      Digest::SHA1.hexdigest("#{password}#{salt}")
    end
    
  end
  
  protected
  
  def check_password
    if self.new_record?
      errors.add(:base, "Password can't be blank") if self.password.blank?
      errors.add(:base, "Password must be at least 4 chars long") if self.password.to_s.size < 4
      errors.add(:base, "Password and confirmation does not match") unless self.password == self.password_confirmation
    else
      unless self.password.blank?
        errors.add(:base, "Password must be at least 4 chars long") if self.password.to_s.size < 4
        errors.add(:base, "Password and confirmation does not match") unless self.password == self.password_confirmation
      end
    end
  end
  
  def make_activation_token
    self.activation_token = ActiveSupport::SecureRandom.hex
  end
  
end
