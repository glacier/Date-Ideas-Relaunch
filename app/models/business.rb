class Business < ActiveRecord::Base
  PRICE_RANGE = {'budget' => ['0', '< $10', '$10-$25'],
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
  validates_presence_of :name, :address1, :province, :city, :postal_code, :phone_no
  validates_length_of :name, :minimum => 4
  validates_length_of :address1, :postal_code, :minimum => 5
  validates_length_of :phone_no, :minimum => 10

  attr_accessor :distance, :avg_rating, :rating_img_url, :reviews, :map, :text_excerpt, :group_date_friendly,
                :takes_reservations, :hours, :kids_friendly, :gmaps, :has_yelp_data, :review

  def init
    @reviews = []
    @has_yelp_data = false
  end

  def add_review(review)
    @reviews.push(review)
  end

  def display_address
    d_address = address1
    d_address << ", #{address2}" if address2
    d_address << ", #{city}, #{province}"
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

  acts_as_gmappable :process_geocoding => false, :validation => false

  def gmaps4rails_address
    display_address
  end

  def gmaps4rails_infowindow
    # add here whatever html content you desire, it will be displayed when users clicks on the marker
    "#{self.name}<br/>#{self.display_address}<br/>#{self.phone_no}"
  end


  def Business.search_by_district_subsection(city, district_subsection, price_point, categories, page)
    msg="city:%s district subsection:%s price point:%s categories:%s page:%s" % [city, district_subsection, price_point, categories, page]
    Rails.logger.info msg
    sql = ''
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

  def Business.search_by_neighbourhood(city, neighbourhood, price_point, categories, page)
    msg=" city :% s neighbourhood :% s price point :% s categories :% s page :% s " % [city, neighbourhood, price_point, categories, page]
    Rails.logger.info msg
    sql = ''
    sql <<
        " SELECT b.*                                  \
    FROM                                         \
        businesses b                               \
      WHERE                                        \
            b.dna_pricepoint IN (?)                \
        AND (b.deleted IS NULL OR                  \
             b.deleted = ?)                       \
        AND EXISTS (SELECT 1                      \
               FROM business_neighbourhoods bn     \
                    , neighbourhoods n              \
               WHERE n.id=bn.neighbourhood_id      \
                 AND bn.business_id=b.id           \
                 AND n.neighbourhood= ?             \
                 AND n.city= ?)                    \
        AND EXISTS (SELECT 1                      \
               FROM business_categories bc         \
                    , categories c                  \
              WHERE c.id=bc.category_id            \
              AND bc.business_id=b.id              \
              AND (c.name IN (?) OR                \
                   c.parent_name IN (?) OR
    c.parent_name IN (SELECT 1                      \
                                        FROM categories c1          \
                                       WHERE c1.parent_name IN (?)) \
                  ))                                                \
      ORDER BY b.name "
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

  def Business.search_by_postal_code(city,postal_code, price_point, categories, page)
      puts "search_by_neighbourhood(#{city}, #{postal_code},#{price_point},#{categories},#{page})"
      sql = ""
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
                 AND n.postal_code=?               \
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
                                            postal_code,
                                            city,
                                            categories,
                                            categories,
                                            categories]).paginate(:page => page, :per_page => 8)
      return db_businesses
  end
end
