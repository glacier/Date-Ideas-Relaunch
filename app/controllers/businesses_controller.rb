class BusinessesController < ApplicationController
  def index
    @businesses = Business.all
  end
  
  def show
    @business = Business.find(params[:id])
  end
  
  def edit
    @business = Business.find(params[:id])
  end
  
  def new
    @business = Business.new
    respond_to do |format|
       format.html # new.html.erb
       format.xml  { render :xml => @post }
     end
  end
  
  def create
    @business = Business.new(params[:business])
    
    respond_to do |wants|
      if @business.save
        flash[:notice] = 'Business was successfully created.'
        wants.html { redirect_to(@business) }
        wants.xml { render :xml => @business, :status => :created, :location => @business }
      else
        wants.html { render :action => "new" }
        wants.xml { render :xml => @business.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  
  def update
    # y params[:business]
    @business = Business.find(params[:id])  
    # redirect_to(business_url(@venue.id))
    if @business.update_attributes(params[:business])
           redirect_to(businesses_path, :notice => 'Venue listing was successfully updated.')
    end
  end
  
  def destroy
    @business = Business.find(params[:id])
    @business.destroy
  end
end
