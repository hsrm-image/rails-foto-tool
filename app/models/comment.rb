class Comment < ApplicationRecord
    belongs_to :image
    belongs_to :user, optional: true

    validates :username, length: {in: 2..50}
    validates :text, length: { in: 5..1000 }
    validates :session_id, presence: true
end
