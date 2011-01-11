class User < ActiveRecord::Base
<<<<<<< HEAD
  has_one :profile #:dependent => :destroy #removes user profile if user is delete
  
  # TODO: link user reviews to user model
  # has_many :review
  
=======
  has_one :profile

>>>>>>> profile
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :lockable and :timeoutable
  devise :database_authenticatable, #:registerable,
         :recoverable, :rememberable, :trackable, :validatable
         

  # Setup accessible (or protected) attributes for your model
<<<<<<< HEAD
  attr_accessible :first_name, :last_name, :user_name, :birthday, 
                  :email, :password, :password_confirmation, :remember_me
=======
  attr_accessible :first_name, :last_name, :username, :email, :password, :password_confirmation, :remember_me
  
  # after_create :create_profile
>>>>>>> profile

end
