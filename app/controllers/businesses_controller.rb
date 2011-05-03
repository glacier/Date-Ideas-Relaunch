class BusinessesController < ApplicationController
  # before_filter :authenticate_admin!
  load_and_authorize_resource

  def index
    current_page = params[:page]
    @businesses = Business.all.paginate(:page => current_page, :per_page => 10)
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
    @business = Business.find(params[:id])  

    @business.neighbourhoods = Neighbourhood.find(params[:neighbourhood_ids]) if params[:neighbourhood_ids]
    @business.categories = Category.find(params[:category_ids]) if params[:category_ids]
    if( params[:deleted] )
      @business.deleted = true
    else
      @business.deleted = false
    end

    logger.info("deleted:" + @business.deleted.to_s )
    if @business.update_attributes(params[:business])
           redirect_to(businesses_path, :notice => 'Venue listing was successfully updated.')
    end
  end
  
  def destroy
    @business = Business.find(params[:id])
    @business.destroy
  end
end
