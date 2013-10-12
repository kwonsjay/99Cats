class User < ActiveRecord::Base
  attr_accessible :password, :user_name

  validates :user_name, :password_digest, :presence => true

  has_many :cats

  has_many :cat_rental_requests

  has_many :session_logs

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

  def active_local_sessions
    SessionLog.active_session_logs_for_user(self)
  end

  def create_local_session(session_hash)
    session_log = self.session_logs.create!(session_hash)
    session_log.local_session_token
  end

  def end_local_session(local_session_token)
    session_log = SessionLog.find_by_local_session_token(local_session_token)
    session_log.status = "INACTIVE"
    session_log.save!
    if active_local_sessions.count == 0
      reset_session_token!
    end
  end

  def end_local_sessions(ids)
    SessionLog.where("id IN (?)", ids).update_all(:status => "INACTIVE")
    if active_local_sessions.count == 0
      reset_session_token!
    end
  end
end
