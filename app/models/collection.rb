class Collection < ApplicationRecord
    has_and_belongs_to_many :tags
    belongs_to :user
    has_and_belongs_to_many :images
    has_many :ratings, as: :rateable
end
