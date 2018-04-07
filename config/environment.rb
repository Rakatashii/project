# Load the Rails application.
require_relative 'application'

# With this, the microposts model recognizes 'mount_uploader :picture, PictureUploader'
require 'carrierwave/orm/activerecord'

# Initialize the Rails application.
Rails.application.initialize!
