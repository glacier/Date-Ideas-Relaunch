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

  attr_accessor :venue, :location, :pricePoint
  def initialize(venue="", location="", pricePoint="")
    @venue = venue
    @location = location
    @pricePoint = pricePoint
  end
end
