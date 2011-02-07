class User
  include Mongoid::Document
  include Mongoid::Timestamps


  index :email, :unique => true
  
  attr_accessor :password

  attr_protected :password_hash, :password_salt

  field :email, :type => String
  field :username, :type => String
  field :password_hash, :type => String
  field :password_salt, :type => String
  field :token, :type => String, :default => nil
  field :is_admin?, :type => Boolean, :default => false
  
  before_validation :prepare_password

  validates_presence_of :email, :username, :password_hash, :password_salt
  validates_uniqueness_of :email
  validates_format_of :email, :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i
  validate :check_password

  def to_param
    email
  end
  

  def self.authenticate(login, pass)
    user = first(:conditions => {:email => login})
    return user if user && user.matching_password?(pass)
  end

  def matching_password?(pass)
    self.password_hash == encrypt_password(pass)
  end
  

  private
    
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
    else
      unless self.password.blank?
        errors.add(:base, "Password must be at least 4 chars long") if self.password.to_s.size.to_i < 4
      end
    end
  end
end
