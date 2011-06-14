class Event < ActiveRecord::Base
  validates_presence_of :eventid
  validates_uniqueness_of :eventid
    
  # mapping of venue type in wizard search form to the proper eventful.com category id
  @@EVENT_CATEGORY = { 
    'activities_events' => 'festivals_parades', #attractions, family_fun_kids
    'arts_entertainment' => 'performing_arts', #performing_arts, art, music
    'bars' => 'singles_social',
    'nightlife' => 'singles_social',
    'food' => 'food',
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

  # For now, don't save event descriptions.  Note that the descriptions returned from the Eventful API can contain HTML tags and can be very verbose.
#  validates :start_time, :venue_name, :venue_address, :presence => true


  # :description --  Don't see the utility of saving this. The descriptions returned from the Eventful API can contain HTML tags and can be very verbose.
end
