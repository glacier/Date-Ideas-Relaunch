class CreateEvents < ActiveRecord::Migration
  def self.up
    create_table :events do |t|
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
      t.string :eventid
    end
  end

  def self.down
    drop_table :events
  end
end
