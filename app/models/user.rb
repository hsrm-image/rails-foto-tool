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

    def count_admins
      User.where(:admin => true).count
    end
end
