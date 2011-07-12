class Dashboard::SignificantDatesController < ApplicationController

  # Not sure we need an index, all this info is going to be displayed on the dashboard
  def index
    @user = current_user
    @significant_dates = @user.significant_dates

  end

  def create
    # composed of title, date (time), notes, and user_id
    @significant_date = SignificantDate.create(params[:significant_date])
    flash.notice= "Significant Date #{@significant_date.title} saved."
    render :controller => :dashboard
  end

  def new
    @significant_date = SignificantDate.new
  end
end
