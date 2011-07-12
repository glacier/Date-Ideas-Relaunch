class FarmedInfo < ActiveRecord::Base
  validates_presence_of :neighbourhood, :categories, :loaded, :offset
end
