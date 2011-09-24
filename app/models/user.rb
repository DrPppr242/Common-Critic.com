class User < ActiveRecord::Base
  attr_accessor :password
  attr_accessible :email, :password, :salt, :password_confirmation

  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates :email, :presence   => true,
                    :uniqueness => { :case_sensitive => false },
                    :format     => { :with => email_regex }

  validates :password, :confirmation => true,
                       :presence     => true,
                       :length       => { :minimum => 6 }

  validates :password_confirmation, :presence => true
  validates_confirmation_of :password, :message => "Passwords do not match"

  before_save :encrypt_password

  def self.authenticate(email, password)
    user = find_by_email(email)
    if user && user.pass_hash == BCrypt::Engine.hash_secret(password, user.salt)
      user
    else
      false
    end
  end

  def encrypt_password
    if password.present?
      self.salt = BCrypt::Engine.generate_salt
      self.pass_hash = BCrypt::Engine.hash_secret(password, salt)
    end
  end
end
