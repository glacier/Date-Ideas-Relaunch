class DateIdeas::DnaService
  PRICE_RANGE = { 'budget' => ['0','< $10','$10-$25'],
                  'moderate' => ['$25-$50'],
                  'high_roller' => ['$50+'],
                 }
  CATEGORIES = { 'food' => ['food','restaurants'],
                 'bars' => ['bars'],
                 'activities_events' => ['active'],
                 'nightlife' => ['nightlife'],
                 'arts_entertainment' => ['arts'],
               }
  def initialize(logger)
    @logger = logger
  end
  def search(venue_type,location,price_point = 'budget',page = '1')
    puts("DateIdeas.search:" << venue_type.to_s << ":" << location.to_s << ":" << price_point.to_s << ":" << page.to_s)

    where_clause = String.new

    where_clause << "neighbourhoods.district_subsection=? \
                     AND businesses.dna_pricepoint IN (?) \
                     AND (businesses.deleted IS NULL OR businesses.deleted = ? ) \
                     AND (categories.name IN (?) \
                          OR categories.parent_name IN (?) \
                          OR categories.parent_name in (select 1 from categories c1 where c1.parent_name in (?)) )"

    neighbourhoods = Array.new
    db_businesses = Business.find(:all,
                               :joins => [:neighbourhoods,
                                          :categories],
                               :conditions => [where_clause,
                                               location,
                                               PRICE_RANGE.fetch(price_point),
                                               false,
                                               CATEGORIES.fetch(venue_type),
                                               CATEGORIES.fetch(venue_type),
                                               CATEGORIES.fetch(venue_type) ] ).paginate(:page => page, :per_page => 4)
    db_businesses_no_exerpt = Array.new

    db_businesses.each do |b|
      if ( b.external_id.nil? )
        if ( b.longitude.nil? || b.latitude.nil? )
          address = get_address(b)
          geocode = get_geocode(address)
          business = Business.find_by_id(b.id)
          business.longitude = geocode.lng
          business.latitude  = geocode.lat
          business.save
        end
        b.neighbourhoods.collect {|hood| neighbourhoods.push(hood.neighbourhood) } #flatten list of neighbourhood objects and add it to the list.
      elsif( b.text_excerpt.nil? || b.text_excerpt.size == 0 )
        @logger.info("business with no exerpt :" + b.external_id )
        db_businesses_no_exerpt.push(b)
      end
    end

    @logger.info("neighbourhoods:" + neighbourhoods.to_s)
    #grab from Yelp
    yelp_adaptor = DateIdeas::YelpAdaptorV2.new('Z720kWRw-CAauOQNUbMEAQ','e7999uMADazHkmG5NDVDWBykczc','1Gj9nSZwzv_o5F_egAYGgYDBsdTdeKFZ','Yd98KQPlSAOWXfmHYsTctbihEH4', @logger ,false)
    yelp_businesses = yelp_adaptor.search('Toronto',CATEGORIES.fetch(venue_type), neighbourhoods)

    merged_businesses = merge(db_businesses, yelp_businesses)

    #search business details
    merged_businesses.each do |b|
      if(!b.external_id.nil? && (b.text_excerpt.nil? ||b.text_excerpt.size == 0))
        business_detail = yelp_adaptor.business_detail(b.external_id)
        b.text_excerpt = business_detail.reviews[0].text_excerpt
        @logger.info("b.excerpt :" +b.text_excerpt)
      end
    end



    return merged_businesses
  end
  def get_geocode(address)
    puts('starting geocoder call for address: '+address)
    result = Geokit::Geocoders::MultiGeocoder.geocode(address)
    @logger.info("result"<<result.to_s)
    return result
  end
  def get_address(business)
    address = String.new
    address.concat(business.address1)

    if ! (business.address2.nil? || business.address2.empty?)
      address.concat(", ").concat(business.address2)
    end

    if ! (business.address3.nil? || business.address3.empty?)
      address.concat(", ").concat(business.address3)
    end

    if ! (business.city.nil? ||   business.city.empty?)
      address.concat(", ").concat(business.city)
    end

    if ! (business.province.nil? || business.province.empty?)
      address.concat(", ").concat(business.province)
    end
    if ! (business.country.nil? || business.country.empty?)
      address.concat(", ").concat(business.country)
    end
    return address
  end
  def merge(businesses, yelp_businesses)
    if( !yelp_businesses.nil? )
      businesses.each do | b |
        if(b.external_id.nil?)
          yelp_businesses.each do |y|
            if( (b.name.eql?(y.name) && b.address1.eql?(y.address1)) || (b.name.eql?(y.name) && b.longitude == y.longitude && b.latitude == y.latitude) )
              b.photo_url = y.photo_url
              #merge the reviews
              b.reviews = y.reviews
              b.longitude = y.longitude
              b.latitude = y.latitude
              break
            end
          end
        end
      end
    end
    return businesses
  end
end
