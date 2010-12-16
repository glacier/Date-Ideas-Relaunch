class WizardController < ApplicationController
  def index
  end
  def search
     request = Yelp::Review::Request::Location.new(
             :address => '650 Mission St',
             :city => 'San Francisco',
             :state => 'CA',
             :radius => 2,
             :term => 'cream puffs',
             :yws_id => '9VeDRJ1tPeDsdRUAkZAukA')
     response = client.search(request)
  end

end
