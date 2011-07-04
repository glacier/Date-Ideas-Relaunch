class BusinessType < ActiveRecord::Base
  validates_presence_of :category_name, :business_id
end
