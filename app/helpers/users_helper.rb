module UsersHelper
  def current_user?(user)
    current_user == user
  end
  
  # Devise helpers
  def resource_name
    :user
  end
 
  def resource
    @resource ||= User.new
  end
 
  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end
end
