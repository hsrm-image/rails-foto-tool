class User < ApplicationRecord
    has_many :images, dependent: :destroy
    has_many :collections, dependent: :destroy

    # Activerecord
    has_one_attached :avatar 
end
