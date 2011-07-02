class BusinessNeighbourhood < ActiveRecord::Base
  belongs_to :business
  belongs_to :neighbourhood
end
