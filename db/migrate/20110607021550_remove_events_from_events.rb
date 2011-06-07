class RemoveEventsFromEvents < ActiveRecord::Migration
  def self.up
    remove_column :events, :events
  end

  def self.down
    add_column :events, :events, :string
  end
end
