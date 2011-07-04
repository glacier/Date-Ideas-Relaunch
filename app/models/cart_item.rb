class CartItem < ActiveRecord::Base
  belongs_to :business
  belongs_to :event
  belongs_to :datecart

  validates :venue_type, :datecart_id, :presence => true
  validate :has_an_event_or_business?

  def type
    return 'event' if business_id.blank?
    return 'business' if event_id.blank?
    'none'
  end

  private

  def has_an_event_or_business?
    @errors.add(:base, "Can't save a cart item unless it has an associated business or event.") unless (business_id || event_id)
  end
end
