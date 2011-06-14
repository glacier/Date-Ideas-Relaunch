class DashboardController < ApplicationController
  def index
    @user = current_user # This is ensured by authenticate_user! in the pre-block of app controller
    datecarts = @user.datecarts

    # Define our sorting algorithm here
    datecarts.sort_by do |cart|
      cart.datetime
    end

    current_datecarts = []
    past_datecarts    = []
    unfinished_datecarts = []

    datecarts.each do |cart|
      next unfinished_datecarts << cart unless cart.datetime
      if cart.datetime <= Time.now
        past_datecarts << cart
      else
        current_datecarts << cart
      end
    end

    @current_datecarts = [] #Sorts the array by their datetimes, then shows the nearest two
    unless current_datecarts.blank?
      2.times do
        cart_item = current_datecarts.pop
        @current_datecarts << cart_item if cart_item
      end
    end

    @past_datecarts = [] #Sorts the array by their datetimes, then shows the nearest two
    unless past_datecarts.blank?
      2.times do
        cart_item = past_datecarts.pop
        @past_datecarts << cart_item if cart_item
      end
    end

    @unfinished_datecarts = [] #Sorts the array by their datetimes, then shows the nearest two
    unless unfinished_datecarts.blank?
      2.times do
        cart_item = unfinished_datecarts.pop
        @unfinished_datecarts << cart_item if cart_item
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