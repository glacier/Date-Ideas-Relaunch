class ApplicationController < ActionController::Base
  protect_from_forgery
  # load_and_authorize_resource
  before_filter :authenticate_user!
  
  # unless config.consider_all_requests_local
  #   rescue_from Exception, :with => :render_error
  #   rescue_from ActiveRecord::RecordNotFound, :with => :render_not_found
  #   rescue_from ActionController::RoutingError, :with => :render_not_found
  #   rescue_from ActionController::UnknownController, :with => :render_not_found
  #   # customize these as much as you want, ie, different for every error or all the same
  #   rescue_from ActionController::UnknownAction, :with => :render_not_found
  # end
  
  private
    
    def render_not_found(exception)
      render :template => "/errors/404.html.erb", :status => 404
    end
  
    def render_error(exception)
      # you can insert logic in here too to log errors
      # or get more error info and use different templates
      render :template => "/errors/500.html.erb", :status => 500
    end

    # gets the current cart in session or create a new one
    def current_cart
      @session_cart = Datecart.find(session[:datecart_id])
    rescue ActiveRecord::RecordNotFound
      # TODO: create cart for current_user
      # TODO: require sign up or login to save
      cart = Datecart.create

      session[:datecart_id] = cart.id
      cart
    end        
end