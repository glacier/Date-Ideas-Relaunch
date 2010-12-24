#require "Yelp"

class WizardController < ApplicationController
  def index
    @wizard = Wizard.new
  end
  def show
    @wizard = Wizard.new
  end
  def create
    @wizard = Wizard.new(params[:wizard][:venue], params[:wizard][:location],params[:wizard][:pricePoint])

    respond_to do |format|
        format.html { render :action =>"show"}
        format.xml  { render :xml => @wizard.errors, :status => :unprocessable_entity }
    end  

  end
end
