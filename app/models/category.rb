class Category < ActiveRecord::Base
  has_many :business_categories
  has_many :businesses, :through => :business_categories

  validates_presence_of :name, :display_name
end
