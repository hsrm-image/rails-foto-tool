module AuthenticateAdmin
  extend ActiveSupport::Concern

  def authenticate_admin!
    authenticate_user!
    unless current_user.admin?
      flash[:alert] = "You have no permissions to do this"
      redirect_back(fallback_location: root_path)
    end
  end
  
end