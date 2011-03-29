class Datecart < ActiveRecord::Base
  #destroys all cart_items if Datecart is destroyed
  has_many :cart_items, :dependent => :destroy
  belongs_to :user
  attr_accessible :user_id, :name, :datetime, :notes
end
