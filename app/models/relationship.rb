class Relationship < ActiveRecord::Base
  # model association based on table indices
  # both follower and followed are User objects
  belongs_to :follower, :class_name => "User"
  belongs_to :followed, :class_name => "User"
  
  attr_accessible :followed_id
end
