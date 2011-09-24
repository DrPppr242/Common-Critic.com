class User < ActiveRecord::Base
  attr_accessible :email, :password, :salt, :password_confirmation

  validates :email, :presence => true, :uniqueness => {:case_sensitive => false}
  validates :password, :confirmation => true

  before_save :encrypt_password

  def self.authenticate(email, password)
    user = find_by_email(email)
    if user && user.password == BCrypt::Engine.hash_secret(password, user.salt)
      user
    else
      false
    end
  end

  def encrypt_password
    if password.present?
      self.salt = BCrypt::Engine.generate_salt
      self.password = BCrypt::Engine.hash_secret(password, salt)
    end
  end
end
