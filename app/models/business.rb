class Business < ActiveRecord::Base
  validates_presence_of :name, :message => "can't be empty"
  
  attr_accessible :map, :id,:photo_url, :name, :url, :longitude, :latitude, :address1,:address2,:address3,:city, :province, :postal_code, :country, :phone_no, :text_excerpt, :distance, :avg_rating, :rating_img_url, :reviews
  
  attr_accessible :venue_type, :logo, :dna_excerpt, :dna_neighbourhood, :dna_atmosphere, :dna_pricepoint, :dna_category, :dna_dresscode, :dna_pictures, :dna_review, :dna_rating_conversation, :dna_rating_convenience, :dna_rating_comfort
  
  def init
    @reviews = Array.new
  end
  def add_review(review)
    @reviews.push(review)
  end
end
