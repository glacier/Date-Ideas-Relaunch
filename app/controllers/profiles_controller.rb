class ProfilesController < ApplicationController
  #require user sign up/sign in to see own profile
  load_and_authorize_resource
  before_filter :authenticate_user!
  
  def index
    @user = current_user
    @profiles = Profile.all
  end
  
  rescue_from ActiveRecord::RecordNotFound do |exception|
    # render :text => "This user profile does not exist"
    Rails.logger.debug('profile does not exist')
    if params[:id].to_i == current_user.id
      redirect_to new_profile_path
    else
      # TODO: Profile not found error
      render :text => "This user profile does not exist"
    end
  end
  
  def show
    @profile = Profile.find(params[:id])
    respond_to do |format|
      if @profile
        format.html { render :action => 'show', :layout => 'dashboard' }
      else
        Rails.logger.debug('profile does not exist')
        if params[:id].to_i == current_user.id
          format.html { redirect_to new_profile_path }
        else
          format.html { render :text => "This user profile does not exist" }
        end
      end
    end
  end

  def new
    @user = current_user
    @profile = Profile.new
    authorize! :new, @profile
    render :layout => 'dashboard'
  end

  def edit    
    @profile = current_user.profile
    authorize! :edit, @profile
    render :layout => 'dashboard'
  end

  # POST /profiles
  # POST /profiles.xml
  def create
    respond_to do |format|
      @profile = current_user.create_profile(params[:profile])
      if @profile 
        format.html { redirect_to(profile_url(@profile.user_id), :notice => 'Profile was successfully created.') }
        format.xml  { render :xml => @profile, :status => :created, :location => @profile }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @profile.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /profiles/1
  # PUT /profiles/1.xml
  def update
    @profile = current_user.profile
    respond_to do |format|
      if @profile
        if @profile.update_attributes(params[:profile])
          format.html { redirect_to(@profile, :notice => 'Profile was successfully updated.') }
          format.xml  { head :ok }
        else
          format.html { render :action => "edit" }
          format.xml  { render :xml => @profile.errors, :status => :unprocessable_entity }
        end
      else
        format.html { render :text => "You currently do not have a profile." }
      end
    end
  end
end
