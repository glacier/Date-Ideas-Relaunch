class Profile < ActiveRecord::Base
  validates_uniqueness_of :user_id
  belongs_to :user
  # how come profiles can be created without a user?!
end
