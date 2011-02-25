class CartItem < ActiveRecord::Base
  belongs_to :business
  belongs_to :datecart
end
