module ApplicationHelper
  def same_session?(id)
    !session.nil? and session[:session_id] == id
  end

  def admin?
    current_user&.admin?
  end

  def same_user?(id)
    !current_user.nil? and current_user[:id] == id
  end
end
