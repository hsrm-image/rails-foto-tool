class Comment < ApplicationRecord
    belongs_to :rating, optional: true
    belongs_to :image
end
