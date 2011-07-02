class DatecartsController < ApplicationController
  # GET /datecarts
  # GET /datecarts.xml
  load_and_authorize_resource
  
  def index
    @datecarts = Datecart.all

    respond_to do |format|
      format.js
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
      
    session[:datecart_id] = @datecart.id
    respond_to do |format|
      format.js
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
      if current_user.profile
        format.js
        format.html { redirect_to(current_user.profile) }
      else
        render :nothing => true
      end
      format.xml  { head :ok }      
    end
  end
  
  # datecart/:datecart_id/clear_cart
  # POST
  def clear_cart
      @datecart = Datecart.find(params[:id])
      @cleared_items = @datecart.cart_items.destroy_all
      
      respond_to do |format|
        format.js
        format.html {redirect_to(@datecart)}
      end
  end
  
  # complete date planning
  def complete
    if current_user
      # if logged in, associate datecart with user
      @datecart = Datecart.find(params[:id])
      @datecart.update_attributes(:user_id => current_user.id)
      if current_user.profile
        redirect_to(current_user.profile)
      else
       redirect_to(@datecart, :notice => 'Datecart was successfully updated.')
      end
    else
      # Ask to sign in 
      redirect_to(new_user_session_path)
    end
  end

  def email
    @datecart = Datecart.find(params[:id])
    if current_user
      UserMailer.date_plan_email(current_user, @datecart).deliver
      redirect_to(@datecart, :notice => 'An email of your Date Plan was sent!')
    else
      redirect_to(new_user_session_path)
    end
  end
  
  # render print view
  def print
    @datecart = Datecart.find(params[:id])
  end
end
