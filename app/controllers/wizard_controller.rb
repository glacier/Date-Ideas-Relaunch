class WizardController < ApplicationController
  autocomplete :neighbourhood, :neighbourhood
    # before_filter :authenticate_user!
  skip_load_and_authorize_resource

  def index
    @user = current_user
    @wizard = Wizard.new
    @datecart = current_cart
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
    @user = current_user
      #set proper event params
    event_cat = params['event_cat']
    event_date = params['event_date']

    @wizard = Wizard.new(params[:venue], event_cat, event_date, params[:location], params[:price_point], params[:neighbourhood], params[:sub_category])

    current_page = params[:page]
    dnaService = DateIdeas::DnaService.new
    eventful = DateIdeas::EventfulAdaptor.new

    @neighbourhoods = Rails.cache.fetch("wizard_search_location_#{@wizard.location}") do
      Neighbourhood.find_by_sql(["SELECT n.* FROM neighbourhoods n WHERE n.district_subsection=? AND EXISTS ( SELECT 1 FROM business_neighbourhoods bn WHERE bn.neighbourhood_id=n.id)", @wizard.location])
    end

    @wizard.sub_categories = Rails.cache.fetch("wizard_search_sub_categories_#{@wizard.venue}") do
      Category.find_by_sql(["SELECT c.* FROM categories c WHERE c.parent_name in (?) AND EXISTS ( SELECT 1 FROM business_categories bc WHERE bc.category_id=c.id)", DateIdeas::DnaService::CATEGORIES[@wizard.venue]])
    end

    @wizard.businesses = dnaService.search(@wizard.venue, @wizard.location, @wizard.price_point, current_page, 8, @wizard.neighbourhood, @wizard.sub_category)

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

    Rails.logger.info "Eventful Search Params\n#{event_cat}\n#{event_date}"

    @wizard.events = eventful.search(event_cat, event_date, 'toronto', 30).paginate(:page => current_page_events, :per_page => per_page)

    @datecart = current_cart

    respond_to do |format|
      if @wizard.venue == 'activities_events'
        format.js { render :action => "show_events", :layout => 'results' }
        format.html { render :action => "show_events", :layout => 'results' }
      else
        format.js { render :action => "show", :layout => 'results' }
        format.html { render :action => "show", :layout => 'results' }
      end
    end
  end
end
