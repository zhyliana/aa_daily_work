class User < ActiveRecord::Base
  attr_reader :password, :password_digest

  before_validation :ensure_session_token

  validates(
  :user_name,
  :session_token,
  uniqueness: true
  )

  has_many(
  :cats,
  class_name: 'Cat',
  primary_key: :id,
  foreign_key: :user_id
  )

  def self.find_by_credentials(creds)
    @user = User.find_by_user_name(creds[:username])

    if @user.try(:is_password?, creds[:password])
      return @user
    else
      nil
    end
  end

  def password=(plaintext)
    @password = plaintext
    self.password_digest = BCrypt::Password.create(plaintext)
  end

  def is_password?(plaintext)
    BCrypt::Password.new(password_digest).is_password?(plaintext)
  end

  def ensure_session_token
    self.session_token ||= SecureRandom.hex
  end

  def reset_session_token!
    self.session_token = SecureRandom.hex
    self.save!
    self.session_token
  end

  private
  def user_params
    params.require(:user).permit(:user_name, :password)
  end
end

