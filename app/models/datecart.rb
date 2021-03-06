class Datecart < ActiveRecord::Base
  #destroys all cart_items if Datecart is destroyed
  has_many :cart_items, :dependent => :destroy

  belongs_to :user
  belongs_to :significant_date

  validate :has_info_when_assigned_to_user?

  def location
    items = cart_items
    first_venue = items.first unless items.empty?
    if first_venue
      location = first_venue.business_id ? first_venue.business.address1 : first_venue.event.venue_address
    else
      location = ""
    end
    location
  end

  def cart_empty?
    return true if cart_items.empty?
    false
  end

  def display_datetime
    return datetime.strftime('%Y/%m/%d %I:%M %P') if datetime
    ""
  end

  private

  def has_info_when_assigned_to_user?
    if user_id
      if cart_items.blank?
        @errors.add(:base, "You can't save a datecart without any associated events or venues.") #Add link or something to make that happen
      end
      unless name
        @errors.add(:name, "can't be blank.")
      end
      unless datetime
        @errors.add(:base, "You must choose a time for your date.")
      end
    end
  end
end
