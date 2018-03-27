class User < ApplicationRecord
  #require 'pry'
  has_many :microposts, dependent: :destroy
  # ensures that all of a users microposts will be destroyed upon user deletion
  attr_accessor     :remember_token, :activation_token, :reset_token
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
  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
    #BCrypt overrides the '==' operator, which is why this is so confusing...
    # Basically, ~if BCrypt translated remember_token into remember_digest..
  end
  def forget
    update_attribute(:remember_digest, nil)
  end
  # Activates an account
  def activate
    update_columns(activated: true, 
                   activated_at: Time.zone.now)
  end
  # Sends activation email
  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end
  def create_reset_digest
    self.reset_token = User.new_token
    update_columns(reset_digest: User.digest(reset_token),  
                   reset_sent_at: Time.zone.now)
  end
  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end
  def password_reset_expired?
    reset_sent_at < 2.hours.ago
  end
  def feed
    Micropost.where("user_id = ?", id)
  end
  
  private
  
    def downcase_email
      self.email.downcase!
    end
    def create_activation_digest
      self.activation_token = User.new_token
      self.activation_digest = User.digest(activation_token)
    end
  #binding.pry
end
