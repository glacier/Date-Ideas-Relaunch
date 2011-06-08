class CreateSignificantDates < ActiveRecord::Migration
  def self.up
    create_table :significant_dates do |t|
      t.string :title
      t.datetime :date #The actual details of the activities for the date are in the datecarts associated with the event
      t.text :notes
      t.timestamps
    end
  end

  def self.down
    drop_table :significant_dates
  end
end
