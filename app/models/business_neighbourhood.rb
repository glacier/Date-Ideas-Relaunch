class BusinessNeighbourhood < ActiveRecord::Base
  belongs_to :business
  belongs_to :neighbourhood

  validates_presence_of :business_id, :neighbourhood_id
end
