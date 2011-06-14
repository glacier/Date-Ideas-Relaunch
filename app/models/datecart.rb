class Datecart < ActiveRecord::Base
  #destroys all cart_items if Datecart is destroyed
  has_many :cart_items, :dependent => :destroy
  validates_associated :cart_items
  
  belongs_to :user
<<<<<<< HEAD
  belongs_to :significant_date

  # Waiting on WIll's confirmation of all validations
  # validates :user_id, :name, :datetime, :presence => true

=======
  attr_accessible :user_id, :name, :datetime, :notes
  
  def cart_empty?
    if cart_items.empty?
      return true
    end
    return false
  end
>>>>>>> d42028d5ebbe6f286e71c78fa5a20d7e29d96c2c
end
