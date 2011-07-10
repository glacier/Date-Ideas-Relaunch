class Wizard
  CITY = ['Toronto','Montreal']
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

  POSTAL_RANGES = [ [5],
                    [10],
                    [20],
                  ]
  attr_accessor :venue, :event_category, :event_date, :location, :price_point, :response, :businesses,
                :neighbourhood_name, :events, :neighbourhoods, :neighbourhood,
                :sub_categories, :sub_category, :city, :province, :postal_code, :country, :range

  def initialize(venue="", event_cat="", event_date="", location="",city="",province="",postal_code="",range="",country="", price_point="")
    @venue = venue
    #location is really district
    if( !postal_code.nil? && postal_code.size > 0 )
      @postal_code = postal_code
      @range = range
    else
      @location = location
    end
    @city = city
    @province = province
    @country = country
    @event_category = event_cat || ""
    @event_date = event_date
    @price_point = price_point
    @businesses = Array.new
  end
  def add_business(business)
    @businesses.push(business)
  end
  def has_neighbourhoods
    return (postal_code.nil? || postal_code.blank?)
  end
end
