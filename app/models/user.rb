class User < ActiveRecord::Base
  has_one :profile
  has_many :datecarts
  has_many :significant_dates
  has_many :authentications
  #model association with following users
  has_many :relationships, :foreign_key => "follower_id", :dependent => :destroy
  has_many :following, :through => :relationships, :source => :followed
  #model association with followers
  has_many :reverse_relationships, :foreign_key => "followed_id",
           :class_name => "Relationship",
           :dependent => :destroy
  has_many :followers, :through => :reverse_relationships, :source => :follower

  has_many :assignments
  has_many :roles, :through => :assignments

  # TODO: link user tips, reviews to user model
  # has_many :tips

  # Email is validated by devise.
  validates_presence_of :email, :first_name, :last_name 
  validates_length_of :first_name, :minimum => 1
  validates_length_of :last_name, :minimum => 1

  # GL - don't validate these for now upon Will's request
  # Then why are these columns even here ...
  # :birthday, :gender
  # remove this column ... this is not used
  # :username
  # validates_length_of :postal_code, :minimum => 5

  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :lockable and :timeoutable
  devise :database_authenticatable, :lockable, :trackable, :timeoutable, :recoverable, :validatable, :registerable 
  # :rememberable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :username, :first_name, :last_name, :birthday, :gender, :postal_code, :password, :password_confirmation
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

  def role?(role_sym)
    roles.any? { |r| r.name.underscore.to_sym == role_sym }
  end
end
