class Rating < ApplicationRecord
    has_one :comment, optional: true
    belongs_to :rateable, polymorphic: true
end
