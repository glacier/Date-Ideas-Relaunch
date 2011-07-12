class NeighbourhoodsController < ApplicationController
  # GET /neighbourhoods
  # GET /neighbourhoods.xml
  def index
    @user = current_user
    @neighbourhoods = Neighbourhood.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @neighbourhoods }
    end
  end

  # GET /neighbourhoods/1
  # GET /neighbourhoods/1.xml
  def show
    @user = current_user
    @neighbourhood = Neighbourhood.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @neighbourhood }
    end
  end

  # GET /neighbourhoods/new
  # GET /neighbourhoods/new.xml
  def new
    @user = current_user
    @neighbourhood = Neighbourhood.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @neighbourhood }
    end
  end

  # GET /neighbourhoods/1/edit
  def edit
    @user = current_user
    @neighbourhood = Neighbourhood.find(params[:id])
  end

  # POST /neighbourhoods
  # POST /neighbourhoods.xml
  def create
    @user = current_user
    @neighbourhood = Neighbourhood.new(params[:neighbourhood])

    respond_to do |format|
      if @neighbourhood.save
        format.html { redirect_to(@neighbourhood, :notice => 'Neighbourhood was successfully created.') }
        format.xml  { render :xml => @neighbourhood, :status => :created, :location => @neighbourhood }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @neighbourhood.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /neighbourhoods/1
  # PUT /neighbourhoods/1.xml
  def update
    @neighbourhood = Neighbourhood.find(params[:id])

    respond_to do |format|
      if @neighbourhood.update_attributes(params[:neighbourhood])
        format.html { redirect_to(@neighbourhood, :notice => 'Neighbourhood was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @neighbourhood.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /neighbourhoods/1
  # DELETE /neighbourhoods/1.xml
  def destroy
    @neighbourhood = Neighbourhood.find(params[:id])
    @neighbourhood.destroy

    respond_to do |format|
      format.html { redirect_to(neighbourhoods_url) }
      format.xml  { head :ok }
    end
  end
end
