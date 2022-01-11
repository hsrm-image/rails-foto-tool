class Image < ApplicationRecord
	has_many :comments, dependent: :destroy
	has_many :ratings, as: :rateable, dependent: :destroy
	has_and_belongs_to_many :collections
	has_and_belongs_to_many :tags
	belongs_to :owner, class_name: 'User', foreign_key: 'owner_id'

	# Activerecord
	has_one_attached :image_file

	#mount_uploader :file, ImageUploader
end
