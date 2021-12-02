module Authenticate
  extend ActiveSupport::Concern
  include ApplicationHelper
  
  def authenticate_admin!
    authenticate_user!
    deny unless admin?
  end
  
  def authenticate_same_session!(id)
    deny unless same_session?(id)
  end

  def authenticate_admin_or_same_session!(id)
    deny unless same_session?(id) or admin?
  end

  private
  def deny
    flash[:alert] = "You have no permissions to do this"
    redirect_back(fallback_location: root_path)
    return false
  end
end