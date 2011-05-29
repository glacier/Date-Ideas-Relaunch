module ApplicationHelper
  include WizardHelper
  
  # Use this function in views to dynamically set the page title
  def title(page_title = nil)
    if page_title
        content_for(:title) do 
          page_title
        end
    else
      content_for(:title) do 
        "page_title"
      end
    end
  end

  # implemented according to railscast episode 244
  def avatar_url(user)
    default_url = "#{root_url}images/guest.jpg"
    if user.profile
      if user.profile.avatar_url.present?
        user.profile.avatar_url
      else
        gravatar_id = Digest::MD5.hexdigest(user.email.downcase)
 "http://gravatar.com/avatar/#{gravatar_id}?s=200&d=#{CGI.escape(default_url)}"
      end
    else
      default_url
    end
  end
  
  def image_url(thing, url)
    default_url = "#{root_url}images/#{thing}_placeholder.jpg"
    if url.nil?
      return default_url
    else
      return url
    end
  end
  def display_time(start_time, end_time)
    if end_time.nil?
      return start_time
    else
      return "From " + start_time + " to " + end_time
    end
  end
end
