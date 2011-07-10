class AddUniqueIndexToEventEventIds < ActiveRecord::Migration
  def self.up
    add_index :events, :eventid, :unique => true
  end

  def self.down
    remove_index :events, :eventid
  end
end
