class Datecart < ActiveRecord::Base
  has_many :cart_items, :dependent => :destroy
  belongs_to :user
end
