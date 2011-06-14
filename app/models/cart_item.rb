class CartItem < ActiveRecord::Base
  belongs_to :business
  belongs_to :event
  belongs_to :datecart

  # Waiting on will's validations
#  validates :venue_type, :datecart_id, :presence => true

#  validate :has_an_event_or_business?

  private

  # xor? Need to check if we want to limit whether an event can also be associated with a business
  def has_an_event_or_business?
    business_id || event_id
  end
end
