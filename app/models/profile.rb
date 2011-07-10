class Profile < ActiveRecord::Base
  RELATIONSHIP = { 'Secret' => 'secret', 'Single' => 'single', 'Dating' => 'dating', 'In a relationship' => 'in_a_relationship', 'Engaged' => 'engaged', 'Married' => 'married'}
  
  validates_presence_of :user, :user_id
  validates_uniqueness_of :user_id

  belongs_to :user
  # how come profiles can be created without a user?!
end