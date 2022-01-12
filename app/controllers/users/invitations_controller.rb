# https://github.com/scambra/devise_invitable/blob/master/app/controllers/devise/invitations_controller.rb
class Users::InvitationsController < Devise::InvitationsController
    include Authenticate
    before_action :configure_permitted_parameters, if: :devise_controller?
    before_action :authenticate_admin!, only: [:new]
    
    protected
  
    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:invite, keys: [:admin, :email])
      devise_parameter_sanitizer.permit(:accept_invitation, keys: [:name, :password, :password_confirmation, :invitation_token])
    end
end