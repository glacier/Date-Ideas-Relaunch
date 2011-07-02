class CartItem < ActiveRecord::Base
  validates_presence_of :business, :unless => "event"
  validates_presence_of :datecart
  validates_associated :event
  
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
