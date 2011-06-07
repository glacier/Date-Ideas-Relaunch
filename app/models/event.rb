class Event < ActiveRecord::Base
  has_many :cart_items
  
  attr_accessible :eventid, :title, :url, :photo_url, :start_time, :end_time, :venue_name, :venue_address, :city_name, :region_name, :postal_code, :latitude, :longitude
  
# :description
# For now, don't save event descriptions.  Note that the descriptions returned from the Eventful API can contain HTML tags and can be very verbose.

end
