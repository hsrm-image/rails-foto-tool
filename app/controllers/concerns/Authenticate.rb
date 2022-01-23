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

  def authenticate_admin_user_session!(s_id, u_id)
    deny unless same_session?(s_id) or same_user?(u_id) or admin?
  end

  private
  def deny
    respond_to do |format|
      format.html { redirect_back(fallback_location: root_path, alert: t("controllers.permission_denied")) }
      format.js {render 'layouts/toast', locals: { :method => "error", :message => t("controllers.permission_denied"), :title => ""}}
    end
    return false
  end
end