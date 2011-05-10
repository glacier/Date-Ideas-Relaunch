class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :authenticate_user!
  helper :all

  # before_filter do |controller|
  #   unless controller.class == Devise::SessionsController
  #     o = controller.class.cancan_resource_class.new(controller)
  #     o.load_and_authorize_resource
  #   end
  # end

  private
    # gets the current cart in session or create a new one
    def current_cart
      @session_cart = Datecart.find(session[:datecart_id])
      @session_cart
    rescue ActiveRecord::RecordNotFound
      # TODO: create cart for current_user
      # TODO: require sign up or login to save
      cart = Datecart.create
      session[:datecart_id] = cart.id
      cart
    end
    
    def authorize
      
    end
end
