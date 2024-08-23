class User < ApplicationRecord
  before_validation { email.downcase! }

  validates :name, presence: true, length: { maximum: 50 }
  validates :email, presence: true, length: { maximum: 255 },
            format: { with:URI::MailTo::EMAIL_REGEXP },
            uniqueness: { case_sensitive: false }
  validates :password, presence: true, length: { minimum: 6 }

  has_secure_password

  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_ocst ? BCypt::Engine::MINCOST : BCrypt::Engine.cost

    Bcrypt::Password.create(string, cost: cost)
  end
end
