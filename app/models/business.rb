class Business < ActiveRecord::Base

  cattr_reader :per_page
  @@per_page = 10
  
  has_many :cart_items
  has_many :business_categories
  has_many :categories, :through => :business_categories
  has_many :business_neighbourhoods
  has_many :neighbourhoods, :through => :business_neighbourhoods

  # before_destroy :ensure_not_referenced_by_any_line_item
  # Waiting on will's validations
  #validates :venue_type, :name, :address1, :province, :city, :presence => true

  attr_accessor :distance, :avg_rating, :rating_img_url, :reviews, :map, :text_excerpt, :group_date_friendly, :takes_reservations, :hours,:kids_friendly,:gmaps
  
  def init
    @reviews = []
  end

  def add_review(review)
    @reviews.push(review)
  end

  # hook method
  def ensure_not_referenced_by_any_line_item
    if cart_items.count.zero?
      return true
    else
      errors.add(:base, 'Cart Items are present')
      return false
    end
  end

  acts_as_gmappable

  def gmaps4rails_address
    display_address
  end
  
  def gmaps4rails_infowindow
    # add here whatever html content you desire, it will be displayed when users clicks on the marker
    "#{name}<br/>#{display_address}<br/>#{phone_no}"
  end

  private
  
  def display_address
    d_address = ""
    d_address << address1
    if(! address2.nil? )
      d_address << ",#{address2}"
    end
    d_address << ",#{city},#{province}"
  end
end
