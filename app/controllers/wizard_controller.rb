class WizardController < ApplicationController
  autocomplete :neighbourhood, :neighbourhood
  # before_filter :authenticate_user!
  skip_load_and_authorize_resource
  
  def index
    @wizard = Wizard.new
    respond_to do |format|
      format.js
      format.html # index.html.erb
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
    @wizard = Wizard.new(params[:venue], params[:location], params[:price_point])
    @wizard.neighbourhood = params[:neighbourhood]
    current_page = params[:page]
    logger.info("creating dnaservice")
    dnaService = DateIdeas::DnaService.new(logger)
    eventful = DateIdeas::EventfulAdaptor.new
    @neighbourhoods = Neighbourhood.find_all_by_district_subsection(@wizard.location)

    businesses = dnaService.search(@wizard.venue, @wizard.location, @wizard.price_point, current_page, 10, @wizard.neighbourhood)
    
    
    per_page = 3
    current_page_events = 1
    if @wizard.venue == 'activities_events'
      per_page = 10
      current_page_events = params[:page]
    end
    #grab events from eventful.com
    events = eventful.search(@wizard.venue, 'toronto', 30).paginate(:page => current_page_events, :per_page => per_page)

    @datecart = current_cart
    @wizard.businesses = businesses
    @wizard.events = events
    
    respond_to do |format|
      if @wizard.venue == 'activities_events'
        format.html { render :action => "show_events"}
      else
        format.html { render :action => "show"}
      end
    end
  end
end
