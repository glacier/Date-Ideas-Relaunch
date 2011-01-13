class User < ActiveRecord::Base
  has_one :profile #:dependent => :destroy #removes user profile if user is delete
  # validates_associated
  
  # TODO: link user reviews to user model
  # has_many :review
  
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :lockable and :timeoutable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :first_name, :last_name, :username, :email, :password, :password_confirmation, :remember_me
end
