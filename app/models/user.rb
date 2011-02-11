class User
  include Mongoid::Document
  include Mongoid::Timestamps


  index :email, :unique => true
  
  attr_accessor :password, :password_confirmation

  attr_protected :password_hash, :password_salt

  before_create :make_activation_token

  after_create :send_activation_mail

  before_validation :prepare_password

  field :email, :type => String
  field :username, :type => String
  field :password_hash, :type => String
  field :password_salt, :type => String
  field :activation_token, :type => String, :default => nil
  #todo replace boolean by statemachine
  field :state, :type => Boolean, :default => false
  field :admin?, :type => Boolean, :default => false
  

  validates_presence_of :email, :username, :password_hash, :password_salt
  validates_uniqueness_of :email
  validates_format_of :email, :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i
  validate :check_password

  def to_param
    email
  end
  
  def self.authenticate(login, pass)
    user = first(:conditions => {:email => login})
    return user if user && user.active? && user.matching_password?(pass)
  end
  
  def activate!
    self.state = true
    self.activation_token = nil
    save
  end

  def active?
    self.state
  end

  def matching_password?(pass)
    self.password_hash == encrypt_password(pass)
  end

  protected
    
  def prepare_password
    unless password.blank?
      self.password_salt = Digest::SHA1.hexdigest([Time.now, rand].join)
      self.password_hash = encrypt_password(password)
    end
  end
  
  def encrypt_password(pass)
    Digest::SHA1.hexdigest([pass, password_salt].join)
  end

  def check_password
    if self.new_record?
      errors.add(:base, "Password can't be blank") if self.password.blank?
      errors.add(:base, "Password must be at least 4 chars long") if self.password.to_s.size.to_i < 4
      errors.add(:base, "Password and confirmation does not match") unless self.password == self.password_confirmation
    else
      unless self.password.blank?
        errors.add(:base, "Password must be at least 4 chars long") if self.password.to_s.size.to_i < 4
        errors.add(:base, "Password and confirmation does not match") unless self.password == self.password_confirmation
      end
    end
  end

  def make_activation_token
    self.activation_token = self.class.make_token
  end

  def self.secure_digest(*args)
    Digest::SHA1.hexdigest(args.flatten.join('--'))
  end

  def self.make_token
    secure_digest(Time.now, (1..10).map{ rand.to_s })
  end

  def send_activation_mail
    UserMailer.activation_mail(self).deliver
  end

end
