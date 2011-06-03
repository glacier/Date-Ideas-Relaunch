class Event < ActiveRecord::Migration
  def self.up
    t.string :events
    t.string :title
    t.string :url
    t.string :photo_url
    t.string :start_time
    t.string :end_time
    t.string :venue_name
    t.string :venue_address
    t.string :city_name
    t.string :region_name
    t.string :postal_code
    t.string :latitude
    t.string :longitude
  end

  def self.down
    drop_table :events
  end
end
