class SignificantDate < ActiveRecord::Base
  has_many :datecarts

  validates :date, :title, :presence => true
end
