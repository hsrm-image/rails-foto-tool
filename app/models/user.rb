class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :invitable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
    has_many :images, dependent: :destroy, foreign_key: "owner_id"
    has_many :collections, dependent: :destroy, foreign_key: "owner_id"
    has_many :comments

    # Activerecord
    has_one_attached :avatar 

    
    def is_last_admin
      admin && User.where(:admin => true).count <= 1
    end

    def can_revoke_admin(current_user)
      errors.add(:user, "Cannot revoke permissions of last Admin") if is_last_admin
      errors.add(:user, "Cannot edit your own Permissions") if id == current_user[:id]
      return errors.empty?
    end
end
