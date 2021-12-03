module ApplicationHelper
  def same_session?(id)
    !session.nil? and session[:session_id] == id
  end

  def admin?
    current_user&.admin?
  end
end
