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

  def is_active?(*paths)
    # Determine which field in the navbar is active
    # Check if the current controller is the same as the specified controller.
    # This may sometimes fail, for example when using the session-controller. 
    # @active overwrites the controller is these special cases.
    return paths.include?(@active) ? "active" : "" unless @active.nil?
    return paths.include?(controller_name) ? "active" : ""
  end
end
