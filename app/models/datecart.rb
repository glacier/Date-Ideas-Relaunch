class Datecart < ActiveRecord::Base
  #destroys all cart_items if Datecart is destroyed
  has_many :cart_items, :dependent => :destroy
  belongs_to :user
  belongs_to :significant_date

  validates :user_id, :name, :datetime, :presence => true
end
