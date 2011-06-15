class DashboardController < ApplicationController
  def index
    @user = current_user # This is ensured by authenticate_user! in the pre-block of app controller
    datecarts = @user.datecarts
    puts datecarts

    # Define our sorting algorithm here
    datecarts.sort_by do |cart|
      cart.datetime
    end

puts     datecarts.collect {|c| c.datetime}
    @current_datecarts = []
    @past_datecarts = []

    counter = {:upcoming => 0, :past => 0}
    datecarts.each do |cart|
      if t = cart.datetime
        if t <= Time.now
          if counter[:past] < 2
            @past_datecarts << cart
            counter[:past] += 1
          end
        else
          if counter[:upcoming] < 2
            @current_datecarts << cart
            counter[:upcoming] += 1
          end
        end
      end
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
  end
end