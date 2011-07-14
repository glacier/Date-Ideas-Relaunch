class Ability
  # Grants authorization abilities to different types of app users
  # Uses the cancan gem
  include CanCan::Ability
  
  def initialize(user)
    alias_action :create, :update, :destroy => :modify
    alias_action :index => :list
    
    # Allow nonregistered users to use the app
    user ||= User.new
       
    if user.role? :admin
      can :manage, :all
      can :manage, :data_farmers
    else
      # permissions for everyone else, including a guest user
      # if the controller actions require login, devise authentication should kick in
      
      # Explicitly disallow these actions by any other user other than admin
      cannot :manage, [Business, DataFarmer, Neighbourhood]
      can :show, Business
       
      # Only authorize users to modify objects they own
      can :manage, User do |u|
        u.try(:id) == user.id
      end
       
      can :manage, Profile do |p|
        p.try(:user) == user || p.try(:user).blank?
      end
      
      # GL - BUG: This is terrible because carts with no user associated can be modified or viewed by anyone
      # Must be fixed. But I can't figure out a way to handle this without changing datecart saved is implemented.  In the end, the way things are done now is severely flawed.
      can :manage, Datecart do |d|
        # remove d.try(:user).blank? will not allow a user to modify their current date cart that has not been saved ...
        d.try(:user) == user || d.try(:user).blank?
      end
      
      can :manage, CartItem
      can [:begin_complete, :complete, :email, :print, :clear_cart, :calendar, :download_calendar, :subscribe]
      
      # Don't let people list objects, listing action is mostly for our debugging purposes
      # the permissions down here takes precedence over those above
      cannot :index, [Profile, User, Datecart]
      cannot :show, [User, CartItem]
    end
  end
end