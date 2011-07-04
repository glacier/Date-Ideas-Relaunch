require 'eventful/api'
#Implements a rails adaptor for the eventful api
#Uses the eventfulapi gem
class DateIdeas::EventfulAdaptor
  def initialize
    begin
      @app_key = '7zXsjWk67F7qVKtq'
      @eventful = Eventful::API.new @app_key
    rescue Eventful::APIError => e
      Rails.logger.info("There was a problem initializing the Eventful API: #{e}")
    end
  end

  def search(venue_type, date, location, num_pages)
    if venue_type.blank?
      y 'venue_type is blank'
      query = 'tag:festivals || tag:attractions || tag:arts || tag:concerts || tag:music || tag:family || tag:food'
      y query
    end
    
    if date.blank?
      y 'date is blank'
      date = 'today'
    end
      
    if Event.EVENT_CATEGORY.has_key?(venue_type)
      category = Event.EVENT_CATEGORY.fetch(venue_type)
    else
      category = venue_type
    end
    
    results = nil
    begin
      #a ruby hash is returned from an API call
      results = @eventful.call 'events/search',
                               :date => date,
                               :q => query,
                               # :keywords => keywords,
                               :category => category,
                               :within => 5,
                               :location => location,
                               :page_size => num_pages,
                               :units => 'km',
                               :mature => 'safe',
                               :sort_order => 'date'
    rescue Exception => e
      Rails.logger.info("Eventful API call failed with error!!")
    end
    
    if results.nil? or results['events'].nil?
      return Array.new
    end
    
    num_items_found = results['total_items']
    if num_items_found > 0
      hash = results['events']['event']
      create_events(hash, num_items_found)
    else
      return Array.new
    end    
  end
 
  def create_events(events_hash, num_items)
    if num_items == 1
      return [ create_event(events_hash) ]
    end
    
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
