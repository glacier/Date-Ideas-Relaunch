class Event < ActiveRecord::Base
    # mapping of venue type in wizard search form to the proper eventful.com category id
  @@EVENT_CATEGORY = {
      'activities_events' => 'festivals_parades', #attractions, family_fun_kids
      'arts_entertainment' => 'performing_arts', #performing_arts, art, music
      'bars' => 'singles_social',
      'nightlife' => 'singles_social',
      'food' => 'food'
  }

  EVENTFUL_CATEGORIES = {
    'All' => '',
    'Concerts and Tour Dates' => 'music',
    'Kids and Family' => 'family_fun_kids',
    'Festivals' => 'festivals_parades',
    'Film' => 'movies_film',
    'Food and Wine' => 'food' ,
    'Art Galleries and Exhibits' => 'art',
    'Literary and Books' => 'books',
    'Museums and Attractions' => 'attractions',
    'Nightlife and Singles' => 'singles_social' ,
    'Outdoors and Recreation' => 'outdoors_recreation',
    'Performing Arts' => 'performing_arts',
    'Pets' => 'animals',
    'Sports' => 'sports'
  }

  TIMES = {
    'All times' => 'Future',
    'Today' => 'Today',
    'This Week' => 'This Week',
    'Next Week' => 'Next Week',
    'This Month' => Time.new.strftime("%B")
  }

    #define some keywords to narrow down search within a category
    #(optional for api)
  @@EVENT_KEYWORDS = {
      'activities_events' => '',
      'arts_entertainment' => '',
      'bars' => '',
      'nightlife' => 'night',
      'food' => '',
  }

  cattr_reader :EVENT_CATEGORY, :EVENT_KEYWORDS
  has_many :cart_items

  # A valid event must have an event id as defined by the eventful.com api. 
  validates_presence_of :eventid

  # don't validate the following because could be due to missing data from API
  # validates_presence_of :venue_address, :title, :url, :start_time, :venue_name, :city_name, :eventid, :latitude, :longitude
  # validates_length_of :title, :city_name, :minimum => 4
  # For now, don't save event descriptions.  Note that the descriptions returned from the Eventful API can contain HTML tags and can be very verbose.
  # :description --  Don't see the utility of saving this. The descriptions returned from the Eventful API can contain HTML tags and can be very verbose.

end
