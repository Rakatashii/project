class Micropost < ApplicationRecord
  belongs_to :user
  default_scope -> { order(created_at: :desc) } #lambda
  # When is ^ called? automatically?
  mount_uploader :picture, PictureUploader
  validates :user_id, presence: true 
  validates :content, presence: true,
                      length: { maximum: 240 }
end
