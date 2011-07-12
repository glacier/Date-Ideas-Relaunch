class Profile < ActiveRecord::Base
  RELATIONSHIP = { 'Secret' => 'secret', 'Single' => 'single', 'Dating' => 'dating', 'In a relationship' => 'in_a_relationship', 'Engaged' => 'engaged', 'Married' => 'married'}

  belongs_to :user

  validates_presence_of :user_id, :anniversary, :city, :country
end