class ApplicationController < ActionController::Base
  protect_from_forgery
  # load_and_authorize_resource
  before_filter :authenticate_user!

  rescue_from ActiveRecord::RecordNotFound, :with => :render_record_not_found
  rescue_from ActionController::RoutingError, :with => :render_missing_page

   # Catch record not found for Active Record
   def render_record_not_found
     render :template => "shared/404", :layout => false, :status => 404
   end

   # Catches any missing methods and calls the general render_missing_page method
   def method_missing(*args)
     render_missing_page # calls my common 404 rendering method
   end

   # General method to render a 404
   def render_missing_page
     # render :template => "shared/404", :layout => false, :status => 404
     render :layout => "shared/404", :status => 404
   end
   
  private
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