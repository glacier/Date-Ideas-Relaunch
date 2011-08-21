class ApplicationController < ActionController::Base
  protect_from_forgery
  # load_and_authorize_resource
  before_filter :authenticate_user!

  #TODO: After the 404 page is made, render it (don't redirect, users could notice)
  # If an unregistered user gets access denied, then redirect them to the home page
  rescue_from CanCan::AccessDenied do |denied|
    redirect_to "/"
  end

  private
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
    else
      # TODO: create cart for current_user
      # TODO: require sign up or login to save
      cart = Datecart.create(:session_id => session[:session_id], :last_access => DateTime.now)
      user.update_attribute(:active_datecart_id, cart.id) if user
      session[:datecart_id] = cart.id
    end
    cart
  end
end