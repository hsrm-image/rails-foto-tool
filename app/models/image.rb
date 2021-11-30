class Image < ApplicationRecord
    has_many :comments, dependent: :destroy
    has_many :ratings, as: :rateable, dependent: :destroy
    has_and_belongs_to_many :collections
    has_and_belongs_to_many :tags
    belongs_to :owner, :class_name => "User", :foreign_key => 'owner_id'

    # Activerecord
    has_one_attached :image_file

    def get_ratings
        return Rating.where(rateable_id: id, rateable_type: "Image")
    end

    def get_score
        sum = 0
        get_ratings.each{ |x| sum += x.rating }
        1.0 * sum / get_ratings.count
    end

    def has_rated?(user_id) # TODO move this function to the user model?
        Rating.where(rateable_id: id, rateable_type: "Image", user_id: user_id).count > 0
    end

    def get_rate(user_id) # TODO move this function to the user model?
        Rating.where(rateable_id: id, rateable_type: "Image", user_id: user_id).first
    end
end
