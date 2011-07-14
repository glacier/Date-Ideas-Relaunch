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
  
  def get_num_dates_planned user
    user.datecarts.length
  end
  
  def show_last_date user
    dates_planned = user.datecarts
    if dates_planned.length > 0
      last_date = dates_planned[-1]
      if last_date.datetime.past?  
        html = "<p>Your last date was at</p>"
      else
        html = "<p>Your next date is at</p>"
      end
      html <<"<h1>"
      html << link_to(last_date) {last_date.name}
      html << "</h1>"
  	else
  	  html = "<h1>No dates planned yet</h1>"
	  end
	  raw html
  end
  
  private
    def display_text key
      Profile::RELATIONSHIP.invert[key]
    end
end
