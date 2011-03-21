class AddDetailsToDatecarts < ActiveRecord::Migration
  def self.up
    add_column :datecarts, :name, :string
    add_column :datecarts, :datetime, :string
    add_column :datecarts, :notes, :string
  end

  def self.down
    remove_column :datecarts, :notes
    remove_column :datecarts, :datetime
    remove_column :datecarts, :name
  end
end
