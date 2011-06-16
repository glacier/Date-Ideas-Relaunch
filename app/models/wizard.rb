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

  attr_accessor :venue, :location, :price_point, :response, :businesses, :restaurant,
                :activity, :dessert, :neighbourhood_name, :events, :neighbourhoods, :neighbourhood,
                :sub_categories, :sub_category
  
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
