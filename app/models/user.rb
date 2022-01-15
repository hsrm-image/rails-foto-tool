class User < ApplicationRecord
	# Include default devise modules. Others available are:
	# :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
	devise :invitable,
	       :database_authenticatable,
	       :registerable,
	       :recoverable,
	       :rememberable,
	       :validatable
	has_many :images, dependent: :destroy, foreign_key: 'owner_id'
	has_many :collections, dependent: :destroy, foreign_key: 'owner_id'
	has_many :comments, dependent: :destroy

	# Activerecord
	has_one_attached :avatar

	def is_last_admin
		return false unless admin
		return false unless invitation_accepted?
		admins = User.where(admin: true)
		n_admins = 0
		admins.each { |x| n_admins += 1 if x.invitation_accepted? }
		return n_admins <= 1
	end

	def can_revoke_admin(current_user)
		errors.add(:user, I18n.t('users.model.delete_last')) if is_last_admin
		if id == current_user[:id]
			errors.add(:user, I18n.t('users.model.edit_own'))
		end
		return errors.empty?
	end

	def invitation_accepted?
		!invitation_accepted_at.nil? or invited_by_id.nil?
	end
end
