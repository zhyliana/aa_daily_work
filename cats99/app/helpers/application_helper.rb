module ApplicationHelper
  def picture_for(user)
    html = "<div class=\"user-picture\">"
    html += "<img src\"#{user.pucture_url}\" alt=\"#{h(user_name)}\">"
    html += "</div>"
    
    html.html_safe
  end
  
  def highlight(text)
    "<strong class=\"highlight\">#{h(text)}</strong>".html_safe
  end
end
