class CartItem < ActiveRecord::Base
  belongs_to :business
  belongs_to :event
  belongs_to :datecart
  def type
    if business.nil? 
      return 'event'
    end
    if event.nil?
      return 'business'
    end
    return 'none'
  end
end
