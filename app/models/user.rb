class User < ActiveRecord::Base
  has_one :profile

  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :lockable and :timeoutable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
         

  # Setup accessible (or protected) attributes for your model
  attr_accessible :first_name, :last_name, :username, :email, :password, :password_confirmation, :remember_me
  
  # after_create :create_profile

end
