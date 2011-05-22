class Wizard
  VENUES = [['Food','food'],
            ['Bars','bars'],
            ['Arts & Entertainment','arts_entertainment'],
            ['Activities & Events','activities_events'],
            ['Nightlife','nightlife']]
  LOCATIONS = [['Downtown Toronto North','North End'],
               ['Downtown Toronto East','East End'],
               ['Downtown Toronto West','West End'],
               ['Downtown Toronto Core','Downtown Core']]
  PRICE_POINTS = [['Budget','budget'],
                  ['Moderate','moderate'],
                  ['High Roller','high_roller']]
  HEART_IMAGE_URL = { 1.0 => "/images/one_heart.gif", 
                      2.0 => "/images/two_hearts.gif",
                      3.0 => "/images/three_hearts.gif",
                      4.0 => "/images/four_hearts.gif",
                      4.5 => "/images/four_and_half_hearts.gif",
                      5.0 => "/images/five_hearts.gif",
                    }

  attr_accessor :venue, :location, :price_point, :response, :businesses, :restaurant, :activity, :dessert, :neighbourhood_name, :events
  def initialize(venue="", location="", price_point="")
    @venue = venue
    @location = location
    @price_point = price_point
    @businesses = Array.new
  end
  def add_business(business)
    @businesses.push(business)
  end
end
