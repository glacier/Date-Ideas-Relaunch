class Neighbourhood < ActiveRecord::Base
  has_many :business_neighbourhoods
  has_many :businesses, :through => :business_neighbourhoods

  validates_presence_of :district, :neighbourhood, :city, :country
end
