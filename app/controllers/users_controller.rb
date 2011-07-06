class UsersController < ApplicationController
  # TODO: require admin authentication to CRUD users
  # before_filter :authenticate_user!
  
  # TODO: Dateideas registration process
  # step 1: Add a photo; personal information 
  # step 2: invite friends to join

  # GET /users
  # GET /users.xml
  def index
    @users = User.all
  
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @users }
    end
  end

  def edit
    @user = User.find(params[:id])
    respond_to do |format|
      format.html {render :layout => 'dashboard'}
    end
  end
  
  def update
    @user = User.find(params[:id])
    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to(profile_url(@user), :notice => "Your account is successfully updated")}
      else
        format.html { render :edit }
      end
    end
  end
  
  def show
    @user = User.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @user }
    end
  end
end
