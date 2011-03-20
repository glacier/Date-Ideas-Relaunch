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
      @saved_cart = current_user.datecarts.create(current_cart)
      # delete the current cart
      current_cart.destroy
      redirect_to(@saved_cart)
    else
      # I don't think I can create users RESTFULLY using devise 
      # as the authentication method
      # current_cart.create_user
      redirect_to(new_user_session_path)
    end
  end
end
