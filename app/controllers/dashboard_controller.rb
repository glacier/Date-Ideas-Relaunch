class DashboardController < ApplicationController
  def index
    @user = current_user # This is ensured by authenticate_user! in the pre-block of app controller
    datecarts = @user.datecarts

    current_datecarts = []
    past_counter = 0

    datecarts.each do |cart|
      if t = cart.datetime
        if t <= Time.now
          past_counter += 1
          @past_datecart = cart if rand(past_counter) == 0 # Give each past date an equal probability of being chosen
        else
          current_datecarts << cart
        end
      end
    end

    @upcoming_datecarts = [] #Store upcoming dates here
    current_datecarts.sort_by { |c| c.datetime }
    2.times do
      @upcoming_datecarts << current_datecarts.pop unless current_datecarts.empty?
    end

    @significant_dates = @user.significant_dates
    #Need to flush out how to handle significant datecarts, since they'll already be captured above.
#    @significat_datecarts = []
#
#    @significant_dates.each do |date|
#      @significat_datecarts << date.datecarts
#    end

    @profile = Profile.find_by_user_id @user.id

    unless @profile
      # What do we do here if they haven't completed a profile?
      # Why is there a distinction between a profile and a user?
    end


    puts @profile.attributes if @profile
    puts @past_datecart.attributes if @past_datecart
  end
end