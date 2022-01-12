class Comment < ApplicationRecord
    belongs_to :image
    belongs_to :user, optional: true

    validates :username, length: {in: 2..50}
    validates :text, length: { in: 5..1000 }
    validates :session_id, presence: true

    before_save :correct_name
    def correct_name
        unless user_id.nil?
            self.username = User.find(user_id).name
        end
    end

end
