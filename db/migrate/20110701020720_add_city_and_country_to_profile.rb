class AddCityAndCountryToProfile < ActiveRecord::Migration
  def self.up
    add_column :profiles, :city, :string
    add_column :profiles, :country, :string, :default => "Canada"
  end

  def self.down
    remove_column :profiles, :country
    remove_column :profiles, :city
  end
end
