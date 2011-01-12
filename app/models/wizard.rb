class Wizard
  VENUES = [['Arts & Entertainment','arts_entertainment'],
            ['Food & Drinks','food_drinks'],
            ['Activities & Events','activities_events']]
  LOCATIONS = [['Downtown Toronto North','to_north'],
               ['Downtown Toronto East','to_east'],
               ['Downtown Toronto West','to_west'],
               ['Downtown Toronto Core','to_core']]
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

  attr_accessor :venue, :location, :price_point, :response, :businesses, :restaurant, :activity, :dessert
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
