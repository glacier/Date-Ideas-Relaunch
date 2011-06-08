class Dashboard::SignificantDatesController < ApplicationController

  def index
    @user = current_user

    @significant_dates = @user.significant_dates

  end
end
