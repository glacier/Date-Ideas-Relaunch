class UsersController < ApplicationController
  # before_filter :authenticate_admin!  #:except => [:show, :index]
  # before_filter :authenticate_user!, :only => :token
    
  # GET /users
  # GET /users.xml
  def index
    @users = User.all
  end
end
