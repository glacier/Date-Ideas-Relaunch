class User < ActiveRecord::Base
  has_one :profile
  
  # TODO: link user tips, reviews to user model
  # has_many :review
  # has_many :tips
  
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :lockable and :timeoutable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :first_name, :last_name, :username, :email, :password,  :password_confirmation, :remember_me, :gender, :birthday, :postal_code
end
