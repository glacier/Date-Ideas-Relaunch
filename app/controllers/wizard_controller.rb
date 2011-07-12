class WizardController < ApplicationController
  autocomplete :neighbourhood, :postal_code
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

    params[:postal_code] = nil unless params[:postal_code] && params[:postal_code] =~ /(^[ABCEGHJKLMNPRSTVXYabceghjklmnpstvxy]\d[A-Za-z] \d[A-Za-z]\d)$/

    @wizard = Wizard.new(params[:venue], event_cat, event_date, params[:location], params[:city], params[:province],
                         params[:postal_code], params[:range], params[:country], params[:price_point],
                         params[:sub_category], params[:neighbourhood])

    current_page = params[:page]
    dnaService = DateIdeas::DnaService.new
    eventful = DateIdeas::EventfulAdaptor.new

    @neighbourhoods = Rails.cache.fetch("wizard_search_location_#{@wizard.location}", :expires_in => 30.minutes) do
      Neighbourhood.find_by_sql(["SELECT n.* FROM neighbourhoods n WHERE n.district_subsection=? AND EXISTS ( SELECT 1 FROM business_neighbourhoods bn WHERE bn.neighbourhood_id=n.id)", @wizard.location])
    end

    @wizard.sub_categories = Rails.cache.fetch("wizard_search_sub_categories_#{@wizard.venue}", :expires_in => 30.minutes) do
      Category.find_by_sql(["SELECT c.* FROM categories c WHERE c.parent_name in (?) AND EXISTS ( SELECT 1 FROM business_categories bc WHERE bc.category_id=c.id)", DateIdeas::DnaService::CATEGORIES[@wizard.venue]])
    end

    @wizard.businesses = dnaService.search(@wizard.venue, @wizard.location, @wizard.price_point, current_page, 8, @wizard.neighbourhood, @wizard.sub_category, @wizard.city, @wizard.postal_code, @wizard.range)

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

    neighbourhood = Neighbourhood.find_by_city(@wizard.city)

    event_location = "%s, %s, %s" % [neighbourhood.city, neighbourhood.province, neighbourhood.country]
    @wizard.events = eventful.search(event_cat, event_date, event_location, 30).paginate(:page => current_page_events, :per_page => per_page)
    @datecart = current_cart

      #Ugly code everywhere zomg
    @wizard.events.shuffle! unless @wizard.events.blank?
    @wizard.businesses.shuffle! unless @wizard.events.blank?

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
