class Business < ActiveRecord::Base

  cattr_reader :per_page
  @@per_page = 10
  
  has_many :cart_items
  has_many :business_categories
  has_many :categories, :through => :business_categories
  has_many :business_neighbourhoods
  has_many :neighbourhoods, :through => :business_neighbourhoods

  # before_destroy :ensure_not_referenced_by_any_line_item
  
  validates_presence_of :name, :message => "can't be empty"
  
  attr_accessible :map, :photo_url, :name, :url, :longitude, :latitude, :address1,:address2,:address3,:city, :province, :postal_code, :country, :phone_no, :text_excerpt, :distance, :avg_rating, :rating_img_url, :reviews #:id
  
  attr_accessible :venue_type, :logo, :dna_excerpt, :dna_neighbourhood, :dna_atmosphere, :dna_pricepoint, :dna_category, :dna_dresscode, :dna_pictures, :dna_review, :dna_rating_conversation, :dna_rating_convenience, :dna_rating_comfort, :deleted

  attr_accessor :distance, :avg_rating, :rating_img_url, :reviews, :map, :text_excerpt,:group_date_friendly,:takes_reservations,:hours,:kids_friendly
  
  def init
    @reviews = Array.new
  end

  def add_review(review)
    @reviews.push(review)
  end

  def display_address
    d_address = String.new
    d_address.concat(address1)
    if(! address2.nil? )
      d_address.concat(",").concat(address2)
    end
    d_address.concat(",").concat(city)
    d_address.concat(",").concat(province)
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
    return display_address
  end
  
  def gmaps4rails_infowindow
    # add here whatever html content you desire, it will be displayed when users clicks on the marker
    "#{self.name}<br/>#{self.display_address}<br/>#{self.phone_no}"
  end
end
