class SignificantDate < ActiveRecord::Base
  has_many :datecarts
  belongs_to :user

  validates_presence_of :date, :title, :user_id
  validates_length_of :notes, :maximum => 300
end
