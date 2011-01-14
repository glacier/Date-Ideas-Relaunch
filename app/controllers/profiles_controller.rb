class ProfilesController < ApplicationController
  #require user sign up/sign in to see own profile
  before_filter :authenticate_user!
  
  def show
    if @profile = current_user.profile
      @profile
    else
      redirect_to new_profile_path, :user_id => current_user.id
    end
    # respond_to do |format|
    #   format.html # show.html.erb
    #   format.xml  { render :xml => @profile }
    # end
  end

  # create a new profile for the current signed in user
  def new
    @profile = current_user.build_profile :user_id => current_user.id

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @profile }
    end
  end

  def edit    
    @profile = current_user.profile
  end

  # POST /profiles
  # POST /profiles.xml
  def create
    # @profile = Profile.new(params[:profile])
    @profile = current_user.build_profile(params[:profile])

    respond_to do |format|
      if @profile.save
        format.html { redirect_to(@profile, :notice => 'Profile was successfully created.') }
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
    # @profile = Profile.find(params[:id])
    @profile = current_user.profile
    respond_to do |format|
      if @profile.update_attributes(params[:profile])
        format.html { redirect_to(@profile, :notice => 'Profile was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @profile.errors, :status => :unprocessable_entity }
      end
    end
  end
end
