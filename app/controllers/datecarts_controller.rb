class DatecartsController < ApplicationController
  # GET /datecarts
  # GET /datecarts.xml
  def index
    @datecarts = Datecart.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @datecarts }
    end
  end

  # GET /datecarts/1
  # GET /datecarts/1.xml
  def show
    @datecart = Datecart.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @datecart }
    end
  end

  # GET /datecarts/new
  # GET /datecarts/new.xml
  def new
    @datecart = Datecart.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @datecart }
    end
  end

  # GET /datecarts/1/edit
  def edit
    @datecart = Datecart.find(params[:id])
  end

  # POST /datecarts
  # POST /datecarts.xml
  def create
    @datecart = Datecart.new(params[:datecart])

    respond_to do |format|
      if @datecart.save
        format.html { redirect_to(@datecart, :notice => 'Datecart was successfully created.') }
        format.xml  { render :xml => @datecart, :status => :created, :location => @datecart }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @datecart.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /datecarts/1
  # PUT /datecarts/1.xml
  def update
    @datecart = Datecart.find(params[:id])

    respond_to do |format|
      if @datecart.update_attributes(params[:datecart])
        format.html { redirect_to(@datecart, :notice => 'Datecart was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @datecart.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /datecarts/1
  # DELETE /datecarts/1.xml
  def destroy
    @datecart = Datecart.find(params[:id])
    @datecart.destroy

    respond_to do |format|
      format.html { redirect_to(datecarts_url) }
      format.xml  { head :ok }
    end
  end
  
  # complete date planning
  def complete
    if current_user
      @datecart = Datecart.find(current_cart)
      @datecart.update_attributes(:user_id => current_user.id)
      if current_user.profile.nil?
        redirect_to(@datecart)
      else
        redirect_to(current_user.profile)
      end
    else
      # Devise not set to create users RESTFULLY 
      redirect_to(new_user_session_path)
    end
  end

  def email
    @datecart = Datecart.find(params[:id])
    if current_user
      UserMailer.date_plan_email(current_user, @datecart).deliver
      redirect_to(@datecart)
    else
      redirect_to(new_user_session_path)
    end
  end
  
  def print
    # render print view
    @datecart = Datecart.find(params[:id])
  end
end
