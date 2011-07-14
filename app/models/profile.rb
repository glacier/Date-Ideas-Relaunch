class Profile < ActiveRecord::Base
  RELATIONSHIP = { 'Secret' => 'secret', 'Single' => 'single', 'Dating' => 'dating', 'In a relationship' => 'in_a_relationship', 'Engaged' => 'engaged', 'Married' => 'married'}

  belongs_to :user
  
  attr_accessible :anniversary, :city, :country, :sig_other_name, :relationship_status, :about_me
  validates_presence_of :user_id, :city, :country #:anniversary
end