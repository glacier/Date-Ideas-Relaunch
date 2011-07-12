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
      format.xml { render :xml => @users }
    end
  end

  def edit
    @user = User.find(params[:id])
    respond_to do |format|
      format.html { render :layout => 'dashboard' }
    end
  end

  def update
    @user = User.find(params[:id])
    @user.birthday = Date.new(params[:user]["birthday(1i)"].to_i, params[:user]["birthday(2i)"].to_i, params[:user]["birthday(3i)"].to_i)
    @user.first_name= params[:user][:first_name].capitalize
    @user.last_name= params[:user][:last_name].capitalize
    @user.postal_code = params[:user][:postal_code]
    @user.gender = params[:user][:gender]

    if @user.save
      flash.notice= "Your account was successfully updated."
    else
      flash.alert= "There was an error saving your account details."
    end

    respond_to do |format|
      if @user.errors.blank?
        format.html { render :edit, :layout => 'dashboard', :notice => "Your account was successfully updated" }
      else
        format.html { render :edit, :layout => 'dashboard' }
      end
    end
  end

  def show
    @user = User.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml { render :xml => @user }
    end
  end
end
