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

  attr_accessor :distance, :text_excerpt, :avg_rating, :rating_img_url, :reviews, :map
  
  def init
    @reviews = Array.new
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
end
