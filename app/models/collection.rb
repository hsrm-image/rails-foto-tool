class Collection < ApplicationRecord
	belongs_to :owner, class_name: 'User', foreign_key: 'owner_id'
	has_and_belongs_to_many :images
	has_many :ratings, as: :rateable
	belongs_to :header_image,
	           class_name: 'Image',
	           foreign_key: 'header_image',
	           optional: true
end
