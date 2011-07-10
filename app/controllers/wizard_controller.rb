class WizardController < ApplicationController
  autocomplete :neighbourhood, :neighbourhood
  # before_filter :authenticate_user!
  skip_load_and_authorize_resource
  
  def index
    @wizard = Wizard.new
    respond_to do |format|
      format.js
      format.html { render :layout => 'wizard' }
    end
  end

  def show
    @wizard = Wizard.new
    respond_to do |format|
      format.js
      format.html # index.html.erb
    end
  end

  def search
    #set proper event params
    event_cat = params['event_cat']
    event_date = params['event_date']
    @wizard = Wizard.new(params[:venue], event_cat, event_date, params[:location], params[:price_point])
      
    neighbourhood = params[:neighbourhood]
    if( neighbourhood.nil? )
      neighbourhood = 'all_neighbourhoods'
    end

    @wizard.neighbourhood = neighbourhood
    sub_category  = params[:sub_category]
    if( sub_category.nil? )
      sub_category = 'all'
    end
    @wizard.sub_category = sub_category

    current_page = params[:page]
    logger.info("creating dnaservice")
    dnaService = DateIdeas::DnaService.new(logger)
    eventful = DateIdeas::EventfulAdaptor.new
    @neighbourhoods = Neighbourhood.find_by_sql(["SELECT n.* FROM neighbourhoods n WHERE n.district_subsection=? AND EXISTS ( SELECT 1 FROM business_neighbourhoods bn WHERE bn.neighbourhood_id=n.id)", @wizard.location])
    sub_categories = Category.find_by_sql(["SELECT c.* FROM categories c WHERE c.parent_name in (?) AND EXISTS ( SELECT 1 FROM business_categories bc WHERE bc.category_id=c.id)",DateIdeas::DnaService::CATEGORIES.fetch(@wizard.venue)])
    @wizard.sub_categories = sub_categories

    businesses = dnaService.search(@wizard.venue, @wizard.location, @wizard.price_point, current_page, 8, @wizard.neighbourhood,@wizard.sub_category)
    
    # Eventful related searches
    per_page = 3
    current_page_events = 1
    if @wizard.venue == 'activities_events'
      event_cat = params[:event_cat].blank? ? '' : params[:event_cat]
      per_page = 8
      current_page_events = current_page
    else
      event_cat = params[:venue]
      event_date = 'today'
    end
    

    #grab events from eventful.com
    y 'eventful search params'
    y event_cat
    y event_date
    
    events = eventful.search(event_cat, event_date, 'toronto', 30).paginate(:page => current_page_events, :per_page => per_page)

    @datecart = current_cart
    @wizard.businesses = businesses
    @wizard.events = events
    
    respond_to do |format|
      if @wizard.venue == 'activities_events'
        format.js { render :action => "show_events", :layout => 'results'}
        format.html { render :action => "show_events", :layout => 'results'}
      else
        format.js { render :action => "show", :layout => 'results'}
        format.html { render :action => "show", :layout => 'results'}
      end
    end
  end
end
