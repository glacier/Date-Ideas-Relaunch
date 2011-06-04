class CartItem < ActiveRecord::Base
  belongs_to :business
  belongs_to :event
  belongs_to :datecart
end
