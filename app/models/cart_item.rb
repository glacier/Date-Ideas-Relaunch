class CartItem < ActiveRecord::Base
  validates_presence_of :business, :unless => "event"
  validates_presence_of :datecart
  validates_associated :event
  
  belongs_to :business
  belongs_to :event
  belongs_to :datecart

  # Waiting on will's validations
#  validates :venue_type, :datecart_id, :presence => true

#  validate :has_an_event_or_business?

  private

  # xor? Need to check if we want to limit whether an event can also be associated with a business

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
