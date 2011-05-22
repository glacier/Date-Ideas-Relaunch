class Event
  attr_accessor :title, :url, :photo_url, :start_time, :end_time, :venue_name, :venue_address, :city_name, :region_name, :latitude, :longitude
  
  # :description
  # For now, don't save event descriptions.  Note that the descriptions returned from the Eventful API can contain HTML tags and can be very verbose.
  
  def initialize
    # @title = event['title']
    # @url = event['url']
    # @start_time = Time.parse(event['start_time']).strftime("%a, %b %d, %I:%M %p") if event['start_time']
    # @venue_name = event['venue_name']
    # @venue_address = event['venue_address']
    # @city_name = event['city_name']
    # @region_name = event['region_name']
    # @latitude = event['latitude']
    # @longitude = event['longitude']
  end
end
