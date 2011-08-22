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
    query=''
    category=''
    if venue_type.blank?
      y 'venue_type is blank'
      query = 'tag:festivals_parades || tag:attractions || tag:performing_arts || tag:museums || tag:outdoors_recreation || tag:movies_film || tag:sports || tag:animals || tag:music || tag:family_fun_kids || tag:food || tag:singles_social || tag:books'
      y query
    elsif Event.EVENT_CATEGORY.has_key?(venue_type)
      category = Event.EVENT_CATEGORY.fetch(venue_type)
    else
      category = venue_type
    end

    if date.blank?
      y 'date is blank'
      date = 'today'
    end

    results = nil
    begin
      #a ruby hash is returned from an API call
      results = @eventful.call 'events/search',
                               :date => date,
                               :q => query,
                               :category => category,
                               :within => 5,
                               :location => location,
                               :page_size => num_pages,
                               :units => 'km',
                               :mature => 'safe',
                               :sort_order => 'date'
    rescue Exception => e
      Rails.logger.info("Eventful API call failed with error: #{e}")
    end

    if results.nil? or results['events'].nil?
      return []
    end

    num_items_found = results['total_items']
    if num_items_found > 0
      hash = results['events']['event']
      create_events(hash, num_items_found)
    else
      []
    end
  end

  def create_events(events_hash, num_items)
    Rails.logger.debug __FILE__ + __LINE__.to_s
    if num_items == 1
      if event_past? events_hash
        return []
      end
      return [create_event(events_hash)]
    end

    events = []
    events_hash.each do |hash|
      unless event_past? hash
        e = create_event(hash)
        begin
          if e.save
            Rails.cache.write(e.eventid, e, :expires_in => 30.minutes)
            events.push(e)
          else
            Rails.logger.debug "Event failed to be saved in db"
            Rails.logger.debug "INVALID EVENT:\nAttrs:\n#{e.attributes}\nErrors:\n#{e.errors}"
          end
        rescue ActiveRecord::RecordNotUnique
          # Event already exists in db, use object from db and not the api
          e = Event.find_by_eventid(e.eventid)
          Rails.cache.write(e.eventid, e, :expires_in => 30.minutes)
          events.push(e)
        end
      else
        Rails.logger.debug "This event was filtered because it is in the past."
      end
    end
    
    return events
  end

  def event_past?(hash)
    # start_time = nil
    # stop_time = nil
    if !hash['start_time'].blank?
      start_time = Time.parse(get_time(hash['start_time']))
    end

    if !hash['stop_time'].blank?
      stop_time = Time.parse(get_time(hash['stop_time']))
    end

    if stop_time.blank? and start_time.blank?
      return false
    elsif stop_time.blank?
      if start_time.past?
        return true
      end
    elsif stop_time.past?
      return true
    end

    return false
  end

  def create_event(event_hash)
    Event.new({
                  :eventid => event_hash['id'].gsub('@', '-'),
                  :title => event_hash['title'],
                  :url => event_hash['url'],
                  :photo_url => get_photo_url(event_hash, 'medium'),
                  :start_time => get_time(event_hash['start_time']),
                  :end_time => get_time(event_hash['stop_time']),
                  :venue_name => event_hash['venue_name'],
                  :venue_address => event_hash['venue_address'],
                  :city_name => event_hash['city_name'],
                  :region_name => event_hash['region_name'],
                  :postal_code => event_hash['postal_code'],
                  :latitude => event_hash['latitude'],
                  :longitude => event_hash['longitude']
              })
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
