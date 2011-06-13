class Datecart < ActiveRecord::Base
  #destroys all cart_items if Datecart is destroyed
  has_many :cart_items, :dependent => :destroy
  validates_associated :cart_items
  
  belongs_to :user
  attr_accessible :user_id, :name, :datetime, :notes
  
  def cart_empty?
    if cart_items.empty?
      return true
    end
    return false
  end
end
