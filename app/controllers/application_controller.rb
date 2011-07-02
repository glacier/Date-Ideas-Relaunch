class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :authenticate_user!

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