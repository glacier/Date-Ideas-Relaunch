require 'eventful/api'
#Implements a rails adaptor for the eventful api
#Uses the eventfulapi gem
class DateIdeas::EventfulAdaptor
  def initialize
    begin
      @app_key = '7zXsjWk67F7qVKtq'
      @eventful = Eventful::API.new @app_key
    rescue Eventful::APIError => e
      logger.info("There was a problem with the API: #{e}")
    end
  end

  def search(venue_type, location, num_pages)
    # result is a ruby hash
    category = Event.EVENT_CATEGORY.fetch(venue_type)
    keywords = Event.EVENT_KEYWORDS.fetch(venue_type)
    results = @eventful.call 'events/search',
                             :date => 'future',
                             :keywords => keywords,
                             :category => category,
                             :within => 5,
                             :location => location,
                             :page_size => num_pages,
                             :units => 'km',
                             :mature => 'normal',
                             :sort_order => 'date'
    unless results['events'].nil?
      return create_events(results['events']['event'])
    end
    
    return Array.new
  end
 
  def create_events(events_hash)
    events = Array.new
    events_hash.each do |hash|
      e = create_event(hash)
      return_code = Rails.cache.write(e.eventid, e, :expires_in => 30.minutes)
      events.push(e)
    end
    return events
  end
  
  def create_event(event_hash)
    event = Event.new
    event_id = event_hash['id']
    # substitute '@' with a '-' because @ converts to %40 in the url
    event.eventid = event_id.gsub('@','-')
    event.title = event_hash['title']
    event.url = event_hash['url']
    event.photo_url = get_photo_url(event_hash, 'medium')
    event.start_time = get_time(event_hash['start_time'])
    event.end_time = get_time(event_hash['end_time'])
    event.venue_name = event_hash['venue_name']
    event.venue_address = event_hash['venue_address']
    event.city_name = event_hash['city_name']
    event.region_name = event_hash['region_name']
    event.postal_code = event_hash['postal_code']
    event.latitude = event_hash['latitude']
    event.longitude = event_hash['longitude']
    return event
  end

  def get_time(time)
   if time 
    if time.is_a? Time
      result = time.strftime("%a, %b %d, %I:%M %p")
    else 
      result = Time.parse(time).strftime("%a, %b %d, %I:%M %p")
    end
   end
   return result
  end

  def get_photo_url(event_hash, photo_size)
    photo_url = "events_placeholder.jpg"
    unless event_hash['image'].nil?
      photo_url = event_hash['image'][photo_size]['url']
    end
    return photo_url
  end

end
