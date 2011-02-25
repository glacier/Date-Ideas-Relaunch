class ProfilesController < ApplicationController
  #require user sign up/sign in to see own profile
  def index
    @profiles = Profile.all
  end
  
  def show
    respond_to do |format|
      if Profile.exists?(:user_id => params[:id])
        @profile = Profile.find_by_user_id(params[:id])
        y @profile
        format.html
      else
        logger.debug('profile does not exist')
        if params[:id].to_i == current_user.id
          format.html { redirect_to new_profile_path }
        else
          # TODO: Profile not found error
          format.html { render :text => "This user profile does not exist" }
        end
      end
    end
  end

  def new
      @profile = current_user.profile
      if @profile.nil?
        @profile = current_user.build_profile(:user_id => current_user.id)
      else
        # TODO: Profile exists error
        redirect_to(profile_url(@profile.user_id), :notice => "You already have an existing profile")
      end
  end

  def edit    
    @profile = current_user.profile
  end

  # POST /profiles
  # POST /profiles.xml
  def create
    respond_to do |format|
      @profile = current_user.create_profile(params[:profile])
      y params
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
      unless @profile.nil?
        if @profile.update_attributes(params[:profile])
          format.html { redirect_to(profile_url(@profile.user_id), :notice => 'Profile was successfully updated.') }
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
