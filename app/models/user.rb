class User < ActiveRecord::Base
  validates :username, :password_digest, :session_token, presence: true
  validates :username, :session_token, uniqueness: true
  validates :password, length: { minimum: 6, allow_nil: true }
  after_initialize :ensure_session_token

  attr_reader :password

  has_many :subs,
    class_name: "Sub",
    foreign_key: :moderator_id,
    inverse_of: :moderator

  has_many :posts,
    class_name: "Post",
    foreign_key: :author_id,
    inverse_of: :author

  has_many :comments,
    class_name: "Comment",
    foreign_key: :author_id,
    inverse_of: :author
    
  def is_password?(password)
    BCrypt::Password.new(self.password_digest).is_password?(password)
  end

  def password=(password)
    @password = password
    self.password_digest = BCrypt::Password.create(password)
  end

  def self.find_by_credentials(username, password)
    user = User.find_by_username(username)
    user && user.is_password?(password) ? user : nil
  end

  def self.generate_session_token
    token = SecureRandom.urlsafe_base64
    until User.find_by_session_token(token).nil?
      token = SecureRandom.urlsafe_base64
    end
    token
  end

  def reset_session_token
    self.session_token = User.generate_session_token
    self.save!
  end

  def ensure_session_token
    self.session_token ||= User.generate_session_token
  end

end
