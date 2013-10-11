class User < ActiveRecord::Base
  attr_accessible :password, :user_name

  validates :user_name, :password_digest, :presence => true

  before_validation do
    self.session_token ||= reset_session_token!
  end

  def password=(pw)
    return if pw.nil? || pw.empty?
    self.password_digest = BCrypt::Password.create(pw)
  end

  def is_password?(pw)
    BCrypt::Password.new(password_digest).is_password?(pw)
  end

  def reset_session_token!
    self.session_token = SecureRandom.urlsafe_base64(16)
    self.save!
    self.session_token
  end

  def self.find_by_credentials(user_name, password)
    user = User.find_by_user_name(user_name)

    return nil if user.nil?

    return user if user.is_password?(password)

    nil
  end
end
