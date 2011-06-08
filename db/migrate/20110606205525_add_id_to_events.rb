class AddIdToEvents < ActiveRecord::Migration
  def self.up
    add_column :events, :eventid, :string
  end

  def self.down
    remove_column :events, :eventid
  end
end