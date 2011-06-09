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
    current_page = params[:page]
    logger.info("creating dnaservice")
    dnaService = DateIdeas::DnaService.new(logger)   
    eventful = DateIdeas::EventfulAdaptor.new

    businesses = dnaService.search(@wizard.venue, @wizard.location, @wizard.price_point, current_page, 10)
    #grab events
#    events = eventful.search(@wizard.venue, 'toronto')
    
    # logger.info(events)
     
    @datecart = current_cart
    @wizard.businesses = businesses
#    @wizard.events = events
    
    respond_to do |format|
        format.html { render :action =>"show" }
    end
  end
end
