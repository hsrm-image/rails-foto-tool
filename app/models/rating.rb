class Rating < ApplicationRecord
    belongs_to :rateable, polymorphic: true
    validates :rating, presence: true, :inclusion => 1..5
end
