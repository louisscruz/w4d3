class User < ActiveRecord::Base
  has_many :cats,
    primary_key: :id,
    foreign_key: :user_id,
    class_name: :Cat

  has_many :cat_rental_requests,
    primary_key: :id,
    foreign_key: :user_id,
    class_name: :CatRentalRequest

  has_many :session_tokens,
    primary_key: :id,
    foreign_key: :user_id,
    class_name: :SessionToken

  # has_many :rented_cats,
  #   through: :approved_requests,
  #   source: :cat

  after_create :ensure_session_token

  validates :user_name, :password_digest, presence: true, uniqueness: true
  validates :password, length: { minimum: 6, allow_nil: true }

  def self.find_by_credentials(user_name, password)
    user = User.find_by(user_name: user_name)
    user && user.is_password?(password) ? user : nil
  end

  attr_reader :password

  def ensure_session_token
    SessionToken.generate_new_token(self.id)
  end

  def password=(password)
    @password = password
    self.password_digest = BCrypt::Password.create(password)
  end

  def is_password?(password)
    bc_obj = BCrypt::Password.new(self.password_digest)
    bc_obj.is_password?(password)
  end
end
