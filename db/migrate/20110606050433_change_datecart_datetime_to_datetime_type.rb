class ChangeDatecartDatetimeToDatetimeType < ActiveRecord::Migration
  def self.up
    change_column :datecarts, :datetime, :datetime, :default => nil
  end

  def self.down
    change_column :datecarts, :datetime, :string, :default => ""
  end
end
