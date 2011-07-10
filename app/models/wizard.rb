class Wizard
  CITY = [['Toronto', 'toronto'], ['Montreal', 'montreal']]
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

  attr_accessor :venue, :event_category, :event_date, :location, :price_point, :response, :businesses, :restaurant,
                :activity, :dessert, :neighbourhood_name, :events, :neighbourhoods, :neighbourhood,
                :sub_categories, :sub_category


  def initialize(venue="", event_cat="", event_date="", location="", price_point="", neighbourhood = 'all_neighbourhoods', sub_category = 'all')
    @venue = venue
    @location = location
    @event_category = event_cat || ""
    @event_date = event_date
    @price_point = price_point
    @businesses = []
    @neighbourhood = neighbourhood
    @sub_category = sub_category
  end
  def add_business(business)
    @businesses.push(business)
  end
end
