class SessionToken < ActiveRecord::Base
  belongs_to :user,
    primary_key: :id,
    foreign_key: :user_id,
    class_name: :User

  validates :user_id, :token, presence: true
  validates :token, uniqueness: true

  def self.generate_new_token(user_id)
    self.create!(user_id: user_id, token: self.generate_session_token)
  end

  def generate_session_token
    SecureRandom.urlsafe_base64
  end

end
