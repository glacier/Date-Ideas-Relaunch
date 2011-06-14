class Event < ActiveRecord::Base
  has_many :cart_items

  # For now, don't save event descriptions.  Note that the descriptions returned from the Eventful API can contain HTML tags and can be very verbose.
#  validates :start_time, :venue_name, :venue_address, :presence => true
end
