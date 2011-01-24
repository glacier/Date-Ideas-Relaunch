module UsersHelper
  def current_user?(user)
    current_user == user
  end
end
