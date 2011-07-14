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
      
      # Don't let people list objects, listing action is mostly for our debugging purposes
      cannot :index, [Profile, User, Datecart]
      cannot :show, [User, CartItem]
      can :show, Business
       
      # Only authorize users to modify objects they own
      can :manage, User do |u|
        u.try(:id) == user.id
      end
       
      can :manage, Profile do |p|
        p.try(:user) == user || p.try(:user).blank?
      end
      
      # GL - This is terrible because carts with no user associated can be edited by anyone
      # But can't find a way to limit permissions right now without changing how datecart is saved
      can :manage, Datecart do |d|
        d.try(:user) == user || d.try(:user).blank?
      end
      
      can :manage, CartItem
      
      # Note: can another user see someone's unsaved Datecart?
      can [:begin_complete, :complete, :email, :print, :clear_cart, :calendar, :download_calendar, :subscribe]
    end
  end
end