class AddDetailsToDatecarts < ActiveRecord::Migration
  def self.up
    add_column :datecarts, :name, :string, :default => "My Date"
    add_column :datecarts, :datetime, :string, :default => ""
    add_column :datecarts, :notes, :string, :default => "Make it special!"
  end

  def self.down
    remove_column :datecarts, :notes
    remove_column :datecarts, :datetime
    remove_column :datecarts, :name
  end
end
