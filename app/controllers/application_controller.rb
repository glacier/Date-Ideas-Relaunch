class ApplicationController < ActionController::Base
  protect_from_forgery
  # load_and_authorize_resource
  before_filter :authenticate_user!

  # Show dynamic error pages
  # TODO
  # unless config.consider_all_requests_local
  #   rescue_from Exception, :with => :render_error
  #   rescue_from ActiveRecord::RecordNotFound, :with => :render_not_found
  #   rescue_from ActionController::RoutingError, :with => :render_not_found
  #   rescue_from ActionController::UnknownController, :with => :render_not_found
  #   # customize these as much as you want, ie, different for every error or all the same
  #   rescue_from ActionController::UnknownAction, :with => :render_not_found
  #   # display can't be found for pages that are denied to the user
  #   rescue_from CanCan::AccessDenied, :with => :render_not_found
  # end


  private
  
  # Overwriting the sign_out redirect devise helper path
  def after_sign_in_path_for(resource_or_scope)
    stored_location_for(:resource_or_scope) || :dashboard
  end
  
  # gets the current cart in session or create a new one
  def current_cart
    # This style also means that a registered user doesn't have to worry about cookies getting cleared, etc.
    if user = current_user # checks if the user is logged in or unregistered
      cart = Datecart.find_by_id(user.active_datecart_id) #Use this form to avoid throwing an exception
    else
      # Use both the datecart_id and session id to ensure malicious users can't arbitrarily set the datecart value
      # and access other users datecarts
      cart = Datecart.find_by_id_and_session_id(session[:datecart_id], session[:session_id])
    end

    if cart
      cart.update_attribute(:last_access, DateTime.now)
      if cart.user.blank?
        cart.update_attribute(:session_id, session[:session_id])
      end
    else
      # TODO: create cart for current_user
      # TODO: require sign up or login to save
      cart = Datecart.create(:session_id => session[:session_id], :last_access => DateTime.now)
      user.update_attribute(:active_datecart_id, cart.id) if user
      session[:datecart_id] = cart.id
    end
    cart
  end

  def render_not_found(exception)
    render :template => "/errors/404.html.erb", :status => 404
  end

  def render_error(exception)
    render :template => "/errors/500.html.erb", :status => 500
  end

end