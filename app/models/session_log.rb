class SessionLog < ActiveRecord::Base
  attr_accessible :remote_ip, :location, :user_agent, :status

  validates :remote_ip,
    :location,
    :user_agent,
    :status,
    :local_session_token,
    :presence => true

  validates :status, inclusion: { in: ["ACTIVE", "INACTIVE"],
      message: "%{value} is not a valid status" }

  before_validation do
    self.status ||= "INACTIVE"
    self.local_session_token ||= reset_local_session_token!
  end

  belongs_to :user

  def self.active_session_logs_for_user(user)
    SessionLog.where("user_id = ? AND status = 'ACTIVE'", user.id)
  end

  def reset_local_session_token!
    self.local_session_token = SecureRandom.urlsafe_base64(16)
    self.local_session_token
  end

  def computer
    # Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/30.0.1599.69 Safari/537.36
    user_agent.split(/[()]/)[1]
  end
end
