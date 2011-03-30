class WizardController < ApplicationController
  # before_filter :authenticate_user!
  def index
    @wizard = Wizard.new
  end
  
  def show
    @wizard = Wizard.new
  end
  
  def search
    @wizard = Wizard.new(params[:venue], params[:location], params[:price_point])
    current_page = params[:page]
    logger.info("creating dnaservice")
    dnaService = DateIdeas::DnaService.new(logger)
    businesses = dnaService.search(@wizard.venue, @wizard.location, @wizard.price_point, current_page)
    @datecart = current_cart
    @wizard.businesses = businesses
    respond_to do |format|
        format.html { render :action =>"show" }
    end
  end
end
