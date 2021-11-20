class Rating < ApplicationRecord
    has_one :comment, required: false
    belongs_to :rateable, polymorphic: true
end
