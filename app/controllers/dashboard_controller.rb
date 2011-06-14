class DashboardController < ApplicationController
  def index
    @user = current_user # This is ensured by authenticate_user! in the pre-block of app controller
    datecarts = @user.datecarts

    # Define our sorting algorithm here
    datecarts.sort_by do |cart|
      cart.datetime
    end

    @datecarts = [] #Sorts the array by their datetimes, then shows the most recent upcoming two
    unless datecarts.blank?
      2.times do
        cart_item = datecarts.pop
        @datecarts << cart_item if cart_item
      end
    end

    @significant_dates = @user.significant_dates
    @profile = Profile.find_by_user_id @user.id

    unless @profile
      # What do we do here if they haven't completed a profile?
      # Why is there a distinction between a profile and a user?
    end
  end
end