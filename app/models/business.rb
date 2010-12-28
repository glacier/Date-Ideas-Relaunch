class Business
  attr_accessor :id,:photo_url, :name, :address1,:address2,:address3,:distance, :avg_rating
  has_many :review
end