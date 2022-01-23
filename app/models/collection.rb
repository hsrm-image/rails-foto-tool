class Collection < ApplicationRecord
	has_and_belongs_to_many :tags
	belongs_to :owner, class_name: 'User', foreign_key: 'owner_id'
	has_and_belongs_to_many :images
	has_many :ratings, as: :rateable
	belongs_to :header_image,
	           class_name: 'Image',
	           foreign_key: 'header_image',
	           optional: true

	# Kaminari
	paginates_per 3

	def rateable_type
		"Collection"
	end

	def get_ratings
		return Rating.where(rateable_id: id, rateable_type: 'Collection')
	end

	def get_score
		1.0 * get_ratings.sum(:rating) / get_ratings.count
	end

	def has_rated?(session_id)
		get_ratings.where(session_id: session_id).count > 0
	end

	def get_rate(session_id)
		get_ratings.where(session_id: session_id).first
	end
end
