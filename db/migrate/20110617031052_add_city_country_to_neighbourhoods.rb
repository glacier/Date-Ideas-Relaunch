class AddCityCountryToNeighbourhoods < ActiveRecord::Migration
  def self.up
    add_column :neighbourhoods, :city, :string
    add_column :neighbourhoods, :country, :string
    Neighbourhood.update_all ["city = ?,country = ?", 'Toronto','Canada']
  end

  def self.down
    remove_column :neighbourhoods, :country
    remove_column :neighbourhoods, :city
  end
end
