class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
    has_many :images, dependent: :destroy
    has_many :collections, dependent: :destroy

    # Activerecord
    has_one_attached :avatar 
end
