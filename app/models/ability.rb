class Ability
  include CanCan::Ability
  
  def initialize(user)
    if(!user.nil? )
      # alias_action
      if user.role? :admin
        can :manage, :all
        can :manage, :data_farmer
      else
        can :read, :all
        can [:create, :update], [Datecart, Profile, :Relationships]

        # Note: can another user see someone's unsaved Datecart?
        # I think they can.  This might be a security loop hole.
        can :complete, Datecart
        can :email, Datecart
        can :print, Datecart

        cannot :destroy, [Datecart, Profile]
        cannot :manage, :data_farmer

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
end