class Datecart < ActiveRecord::Base
  has_many :cart_items, :dependent => :destroy
  belongs_to :user
  attr_accessible :user_id, :name, :datetime, :notes
end
