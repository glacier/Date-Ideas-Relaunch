class DataFarmer < ActiveRecord::Base
  attr_accessor :city

  validates_presence_of :offset, :saved
end
