class Ability
  # Grants authorization abilities to different types of app users
  # Uses the cancan gem
  include CanCan::Ability
  
  def initialize(user)
    # Allow nonregistered users to use the app
    user ||= User.new
    
    # alias_action
    if user.role? :admin
      can :manage, :all
      can :manage, :data_farmers
    else
      cannot :destroy, [Datecart, Profile]
      cannot :manage, :data_farmers
      
      can :read, :all
      can [:create, :update], [Datecart, Profile, :Relationships]

      # Note: can another user see someone's unsaved Datecart?
      # I think they can.  This might be a security loop hole.
      can [:begin_complete, :complete, :email, :print, :clear_cart, :calendar, :download_calendar, :subscribe], Datecart
      
      # Allow user to manage their own user account
      # Seems to be a linear search -- will it scale to many users/profiles?
      can :manage, User do |u|
        u.try(:id) == user.id
      end

      can :manage, Profile do |p|
        p.try(:user) == user
      end

      can :destroy, Datecart do |d|
        d.try(:user) == user
      end

      # can :manage, Relationship do |r|
      #   r.try(:follower) == user
      # end
    end
  end
end