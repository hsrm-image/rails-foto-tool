class Image < ApplicationRecord
    has_many :comments, dependent: :destroy
    has_many :ratings, as: :rateable, dependent: :destroy
    has_and_belongs_to_many :collections
    has_and_belongs_to_many :tags
    belongs_to :owner, class_name: :user
end
