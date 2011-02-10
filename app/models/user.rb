class User < ActiveRecord::Base
  has_one :profile
  has_many :authentications
  #model association with following users
  has_many :relationships, :foreign_key => "follower_id", :dependent => :destroy
  has_many :following, :through => :relationships, :source => :followed
  #model association with followers
  has_many :reverse_relationships, :foreign_key => "followed_id",
                                    :class_name => "Relationship",
                                    :dependent => :destroy
  has_many :followers, :through => :reverse_relationships, :source => :follower

  # TODO: link user tips, reviews to user model
  # has_many :tips
  
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :lockable and :timeoutable
  devise :database_authenticatable, :lockable, :trackable, :timeoutable
  # :validatable, :registerable, :recoverable, :rememberable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation
  attr_accessible :first_name, :last_name, :username,  :gender, :birthday, :postal_code
  # :remember_me,
  
  def apply_omniauth(omniauth)
    # self.email = omniauth['user_info']['email'] if email.blank?
    authentications.build(:provider => omniauth['provider'], :uid => omniauth['uid'])
  end
  
  # overrides devises super controller
  def password_required?
    (authentications.empty? || !password.blank?) && super
  end
  
  #is the user following 'followed'
  def following?(followed)
    relationships.find_by_followed_id(followed)
  end
  
  #follow another user 'followed'
  def follow!(followed)
    relationships.create!(:followed_id => followed.id)
  end
  
  def unfollow!(followed)
    # relationships.delete(followed)
    relationships.find_by_followed_id(followed).destroy
  end
end
