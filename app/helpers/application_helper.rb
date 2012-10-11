module ApplicationHelper
  def active_link(controller, action)
    return_value = ""
    if params[:controller] == controller && params[:action] == action
      return_value = "class='active'"
    end
    return_value
  end
end
