class BusinessesController < ApplicationController
  # before_filter :authenticate_admin!
  load_and_authorize_resource

  def index
    current_page = params[:page]
    @businesses = Business.all.paginate(:page => current_page, :per_page => 10)
  end
  
  def show
    @business = Business.find(params[:id])
    @json = @business.to_gmaps4rails
    @markers = @business.to_gmaps4rails
    yelp_adaptor = DateIdeas::YelpAdaptorV2.new(logger ,false)
    business_detail = yelp_adaptor.business_detail(@business.external_id)

    scrappy = DateIdeas::ScreenScraper.new(logger)
    scraped_biz_details = Hash.new

    scraped_biz_details = scrappy.get_business_details(@business.external_id)
    logger.info("scraped info:" + scraped_biz_details.to_s)
    if( !business_detail.nil?)
      logger.info("business_detail:" +business_detail.to_s)
      if(!@business.external_id.nil? && (@business.dna_excerpt.nil? ||@business.dna_excerpt.size == 0))
        highest_review = Review.new
        highest_review.rating = 0
        business_detail.reviews.each do |biz_review |
          if( biz_review.rating > highest_review.rating )
            highest_review = biz_review
          end
        end

        @business.dna_excerpt = highest_review.text_excerpt
      end
      @business.reviews = business_detail.reviews

    end
    if( !scraped_biz_details.nil?)
      @business.hours = scraped_biz_details.fetch('hours')
      @business.takes_reservations = scraped_biz_details.fetch('takes_reservations')
      @business.kids_friendly = scraped_biz_details.fetch('kids_friendly')
      @business.dna_dresscode = scraped_biz_details.fetch('dress_code')
      @business.group_date_friendly = scraped_biz_details.fetch('group_date_friendly')
    end
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
