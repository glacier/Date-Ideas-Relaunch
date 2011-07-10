class Profile < ActiveRecord::Base
  belongs_to :user

  validates_presence_of :user_id, :anniversary, :city, :country
end