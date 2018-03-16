class User < ApplicationRecord
  attr_accessor     :remember_token
  before_save       :downcase_email
  before_create     :create_activation_digest
  validates :name,  presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, 
                    length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  has_secure_password # requires BCrypt
  validates :password, presence: true, length: { minimum: 5 }, 
                    allow_nil: true
  class << self
    def digest(string)
      cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
      # ---
      BCrypt::Password.create(string, cost: cost)
    end
    def new_token
      SecureRandom.urlsafe_base64 # Generates 22 character string, w/ each char having 64 possible variations. Hence, 1/64**(-22) == 1/2**(-132) change of colliding.
    end
  end
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end
  # Returns true if the given token matches the digest.
  def authenticated?(remember_token)
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember_token) # == 'Bcrypt.new(remember_digest) == remember_token', where BCrypt overrides the '==' operator.
    # Basically, ~if BCrypt translated remember_token into remember_digest ...
  end
  def forget
    update_attribute(:remember_digest, nil)
  end
  private
  
    def downcase_email
      self.email.downcase!
    end
    def create_activation_digest
      self.activation_token = User.new_token
      self.activation_digest = User.digest(activation_token)
    end
    
end
