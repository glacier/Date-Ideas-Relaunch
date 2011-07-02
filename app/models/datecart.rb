class Datecart < ActiveRecord::Base
  #destroys all cart_items if Datecart is destroyed
  has_many :cart_items, :dependent => :destroy

  belongs_to :user
  belongs_to :significant_date

  # Waiting on WIll's confirmation of all validations
#  validates :user_id, :name, :datetime, :presence => true

  validate :has_date_when_saved?

  def cart_empty?
    if cart_items.empty?
      return true
    end
    return false
  end

  def cart_saved?
    if user
      return true
    end
    return false
  end

  private
  def has_date_when_saved?
    if user_id
      if cart_items.blank?
        @errors.add(:base, "You can't save a datecart without any associated events or venues.")#Add link or something to make that happen
      end
    end
  end
end
