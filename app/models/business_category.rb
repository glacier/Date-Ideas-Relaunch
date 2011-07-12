class BusinessCategory < ActiveRecord::Base
  belongs_to :business
  belongs_to :category

  validates_presence_of :business_id, :category_id
end
