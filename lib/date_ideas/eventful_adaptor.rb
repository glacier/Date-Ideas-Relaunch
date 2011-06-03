require 'eventful/api'

#Implements a rails adaptor for the eventful api
class DateIdeas::EventfulAdaptor

  def initialize
    begin
      @app_key = '7zXsjWk67F7qVKtq'
      @eventful = Eventful::API.new @app_key
    rescue Eventful::APIError => e
      logger.info("There was a problem with the API: #{e}")
    end
  end

  def search(query, location)
    # result is a ruby hash
    results = @eventful.call 'events/search',
                             :date => 'future',     
                             :keywords => query,
                             :location => location,
                             :page_size => 3,
                             :units => 'km',
                             :mature => 'normal',
                             :sort_order => 'popularity'
    unless results['events'].nil?
      return create_events(results['events']['event'])
    end
    
    return Array.new
  end
 
  def create_events(events_hash)
    events = Array.new
    events_hash.each do |hash|
      e = create_event(hash)
      Rails.cache.write("e_" + e.title + "_" + e.start_time, e, :expires_in => 30.minutes)
      events.push(e)
    end
    return events
  end
  
  def create_event(event_hash)
    event = Event.new
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
