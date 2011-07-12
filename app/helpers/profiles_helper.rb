module ProfilesHelper
  def display_private_profile_info(user)
    status = display_text(user.profile.relationship_status)
    anniversary = user.profile.anniversary.to_s
    list=""
    if current_user?(user)			
		  unless status.blank?
				list = content_tag(:li, content_tag(:span, "Relationship status: ") + status)
			end
			
			unless anniversary.blank?
				if status != 'single' and status != 'secret'
  				list << content_tag(:li, content_tag(:span, "Anniversary: ") + anniversary )
				end
			end
		end
		
		content_tag :ul do
		  raw(list)
	  end
  end
  
  def get_dates_planned user
    user.datecarts
  end
  
  def show_last_date dates_planned
    if dates_planned.length > 0
      last_date = dates_planned[-1]
      html = "<p>Your last date was at</p> <h1>"
      html << link_to(last_date) {last_date.name}
      html << "</h1>"
  	else
  	  html = "You haven't planned Any!"
	  end
	  raw html
  end
  
  private
    def display_text key
      Profile::RELATIONSHIP.invert[key]
    end
end
