class Image < ApplicationRecord
	has_many :comments, dependent: :destroy
	has_many :ratings, as: :rateable, dependent: :destroy
	has_and_belongs_to_many :collections
	belongs_to :owner, class_name: 'User', foreign_key: 'owner_id'

	# Activerecord
	has_one_attached :image_file
	validates :image_file,
	          presence: true,
	          blob: {
			content_type: :image,
			size_range: 1..(Rails.configuration.x.image.max_file_size),
	          },
	          on: :create # supported options: :image, :audio, :video, :text
	validates :title, length: { maximum: 50 }
	validates :description, length: { maximum: 1000 }

	# Kaminari
	paginates_per 3

	def rateable_type
		"Image"
	end

	def get_ratings
		return Rating.where(rateable_id: id, rateable_type: 'Image')
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

	def next(logged_in, collection = nil)
		all = get_visible(logged_in, collection)
		all.where('id > ?', id).order('id ASC').first || all.first
	end

	def previous(logged_in, collection = nil)
		all = get_visible(logged_in, collection)
		all.where('id < ?', id).order('id DESC').first || all.last
	end

	def get_visible(logged_in, collection = nil)
		# Only get the images that the user can view
		if collection.nil?
			logged_in ? Image.all : Image.where(processed: true)
		else 
			logged_in ? Collection.find(collection.id).images.all : Collection.find(collection.id).images.where(processed: true)
		end
	end
  
  def description_short
    description.truncate(200)
  end

  def preview
    image_file.variant(resize_to_fill: [Rails.configuration.x.image.preview_image_size, Rails.configuration.x.image.preview_image_size])
  end
end
