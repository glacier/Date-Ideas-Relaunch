class Business
  attr_accessor :id,:photo_url, :name, :longitude, :latitude, :address1,:address2,:address3,:city, :province, :postal_code, :country, :phone_no, :text_excerpt, :distance, :avg_rating, :rating_img_url, :reviews
  def init
    @reviews = Array.new
  end
  def add_review(review)
    @reviews.push(review)
  end
end
