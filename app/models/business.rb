class Business < ActiveRecord::Base
  PRICE_RANGE = { 'budget' => ['0','< $10','$10-$25'],
                  'moderate' => ['$25-$50'],
                  'high_roller' => ['$50+'],
                 }
  cattr_reader :per_page
  @@per_page = 10
  
  has_many :cart_items
  has_many :business_categories
  has_many :categories, :through => :business_categories
  has_many :business_neighbourhoods
  has_many :neighbourhoods, :through => :business_neighbourhoods

  # before_destroy :ensure_not_referenced_by_any_line_item
  
  validates_presence_of :name, :message => "can't be empty"
  
  attr_accessible :map, :photo_url, :name, :url, :longitude, :latitude, :address1,:address2,:address3,:city,
                  :province, :postal_code, :country, :phone_no, :text_excerpt, :distance, :avg_rating, :rating_img_url, :reviews #:id
  
  attr_accessible :venue_type, :logo, :dna_excerpt, :dna_neighbourhood, :dna_atmosphere, :dna_pricepoint,
                  :dna_category, :dna_dresscode, :dna_pictures, :dna_review, :dna_rating_conversation,
                  :dna_rating_convenience, :dna_rating_comfort, :deleted

  attr_accessor :distance, :avg_rating, :rating_img_url, :reviews, :map, :text_excerpt,:group_date_friendly,
                :takes_reservations,:hours,:kids_friendly,:gmaps, :has_yelp_data, :review
  
  def init
    @reviews = Array.new
    @has_yelp_data = false
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
    if(!city.nil?)
      d_address.concat(",").concat(city)
    end
    if(!province.nil?)
      d_address.concat(",").concat(province)
    end
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

  def Business.search_by_district_subsection(city,district_subsection, price_point, categories, page )
    sql = String.new
    sql <<
      "SELECT b.*                                  \
      FROM                                         \
        businesses b                               \
      WHERE                                        \
            b.dna_pricepoint IN (?)                \
        AND (b.deleted IS NULL OR                  \
             b.deleted = ? )                       \
        AND EXISTS ( SELECT 1                      \
               FROM business_neighbourhoods bn     \
                    ,neighbourhoods n              \
               WHERE n.id=bn.neighbourhood_id      \
                 AND bn.business_id=b.id           \
                 AND n.district_subsection=?       \
                 AND n.city=? )                    \
        AND EXISTS ( SELECT 1                      \
               FROM business_categories bc         \
                    ,categories c                  \
              WHERE c.id=bc.category_id            \
              AND bc.business_id=b.id 	           \
              AND (c.name IN (?) OR                \
                   c.parent_name IN (?) OR
                   c.parent_name IN ( SELECT 1                      \
                                        FROM categories c1          \
                                       WHERE c1.parent_name IN (?)) \
                  ))                                                \
      ORDER BY b.name"
      db_businesses = Business.find_by_sql([sql,
                                            PRICE_RANGE.fetch(price_point),
                                            false,
                                            district_subsection,
                                            city,
                                            categories,
                                            categories,
                                            categories]).paginate(:page => page, :per_page => 8)
      return db_businesses
  end
  def Business.search_by_neighbourhood(city,neighbourhood, price_point, categories, page)
      sql = String.new
      sql <<
      "SELECT b.*                                  \
      FROM                                         \
        businesses b                               \
      WHERE                                        \
            b.dna_pricepoint IN (?)                \
        AND (b.deleted IS NULL OR                  \
             b.deleted = ? )                       \
        AND EXISTS ( SELECT 1                      \
               FROM business_neighbourhoods bn     \
                    ,neighbourhoods n              \
               WHERE n.id=bn.neighbourhood_id      \
                 AND bn.business_id=b.id           \
                 AND n.neighbourhood=?             \
                 AND n.city=? )                    \
        AND EXISTS ( SELECT 1                      \
               FROM business_categories bc         \
                    ,categories c                  \
              WHERE c.id=bc.category_id            \
              AND bc.business_id=b.id 	           \
              AND (c.name IN (?) OR                \
                   c.parent_name IN (?) OR
                   c.parent_name IN ( SELECT 1                      \
                                        FROM categories c1          \
                                       WHERE c1.parent_name IN (?)) \
                  ))                                                \
      ORDER BY b.name"
      db_businesses = Business.find_by_sql([sql,
                                            PRICE_RANGE.fetch(price_point),
                                            false,
                                            neighbourhood,
                                            city,
                                            categories,
                                            categories,
                                            categories]).paginate(:page => page, :per_page => 8)
      return db_businesses
  end
end
