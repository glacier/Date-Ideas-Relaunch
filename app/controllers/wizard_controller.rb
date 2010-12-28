class WizardController < ApplicationController
  def index
    @wizard = Wizard.new
  end
  def show
    @wizard = Wizard.new
  end
  def create
    @wizard = Wizard.new(params[:wizard][:venue], params[:wizard][:location],params[:wizard][:pricePoint])
    client = Yelp::Client.new
    request = Yelp::Review::Request::Location.new(
                  :address => '365 Bartlett Ave.',
                  :city => 'Toronto',
                  :state => 'ON',
                  :radius => 10,
                  :term => 'restaurant',
                  :yws_id => '9VeDRJ1tPeDsdRUAkZAukA')
    response = client.search(request)
    @wizard.response = response

    respond_to do |format|
        format.html { render :action =>"show"}
        format.xml  { render :xml => @wizard.errors, :status => :unprocessable_entity }
    end  

  end
end