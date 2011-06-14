class SignificantDate < ActiveRecord::Base
  has_many :datecarts
  belongs_to :user

  # Waiting on will's validations
#  validates :date, :title, :presence => true
end
