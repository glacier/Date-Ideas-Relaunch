require 'eventful/api'
#Implements a rails adaptor for the eventful api
class DateIdeas::EventfulAdaptor
  def initialize
    #dateideas eventful api key
    @app_key = '7zXsjWk67F7qVKtq'
    @eventful = Eventful::API.new @app_key  
  end
  def search(query, location)
    #  begin
    # 
    #   # Start an API session with a username and password
    #   eventful = Eventful::API.new 'application_key',
    #                                :user => 'username',
    #                                :password => 'password'
    # 
    #   # Lookup an event by its unique id
    #   event = eventful.call 'events/get',
    #                         :id => 'E0-001-001042544-7'
    # 
    #   puts "Event Title: #{event['title']}"
    # 
    #   # Get information about that event's venue
    #   venue = eventful.call 'venues/get',
    #                         :id => event['venue_id']
    # 
    #   puts "Venue: #{venue['name']}"
    # 
    # rescue Eventful::APIError => e
    #   puts "There was a problem with the API: #{e}"
    # end
    
    # search for events
    results = @eventful.call 'events/search',
                             :keywords => query,
                             :location => location,
                             :page_size => 5
# example
# http://api.eventful.com/rest/events/search?...&keywords=books&location=San+Diego&date=Future
    
  end
end