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
      # cannot :destroy, Profile
      cannot :manage, :all #[:data_farmers, Business, Neighbourhood]
      # can [:create, :update], Datecart
      # cannot :edit, Datecart
      
      can :manage, CartItem
      
      # Note: can another user see someone's unsaved Datecart?
      can [:begin_complete, :complete, :email, :print, :clear_cart, :calendar, :download_calendar, :subscribe]
    
      # Allow user to manage their own user account
      # Seems to be a linear search -- will it scale to many users/profiles?
      can :manage, User do |u|
        u.try(:id) == user.id
      end
       
      can :manage, Profile do |p|
        p.try(:user) == user
      end
       
      can :manage, Datecart do |d|
        d.try(:user) == user || d.try(:user).blank?
      end
      
      cannot :edit, Datecart do |d|
        d.try(:user) != user
      end
      
      # cannot :index, :all
      cannot :show, [User, CartItem]
    end
  end
end