module ProfilesHelper
  def display_private_profile_info(user)
    status = user.profile.relationship_status
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
end
