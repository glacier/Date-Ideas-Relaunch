CARTOGRAPHER_GMAP_VERSION = 3
# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
DateIdeas::Application.initialize!

if defined?(PhusionPassenger)
  PhusionPassenger.on_event(:starting_worker_process) do |forked|
    # Only works with DalliStore
    Rails.cache.reset if forked
  end
end
