class ApplicationController < ActionController::Base
  protect_from_forgery
  # before_filter :authenticate_user!
  private
    def current_cart
      @session_cart = Datecart.find(session[:datecart_id])
      @session_cart
    rescue ActiveRecord::RecordNotFound
      cart = Datecart.create
      session[:datecart_id] = cart.id
      cart
    end
end
