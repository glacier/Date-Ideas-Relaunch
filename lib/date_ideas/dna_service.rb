class DateIdeas::DnaService
  PRICE_RANGE = { 'budget' => ['< $10','$10-$25'],
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
    categories = Array.new
    neighbourhoods = Array.new
    businesses = Business.find(:all,:joins => [:neighbourhoods,:categories], :conditions => ['neighbourhoods.district_subsection=? AND businesses.dna_pricepoint IN (?) AND (categories.name IN (?) or categories.parent_name IN (?) or categories.parent_name in (select 1 from categories c1 where c1.parent_name in (?)) )',location, PRICE_RANGE.fetch(price_point),CATEGORIES.fetch(venue_type),CATEGORIES.fetch(venue_type),CATEGORIES.fetch(venue_type) ] ).paginate(:page => page, :per_page => 4)
    businesses.each do |b|
      puts("=========================")
      puts("business name:" << b.name)
      if (! b.categories.nil? && !b.categories[0].nil? ) 
        @logger.info("category:" << b.categories[0].name.to_s )
        categories.push( b.categories[0].name )
      else
        puts("category: is null")
      end
      if (! b.neighbourhoods.nil? && !b.neighbourhoods.empty? && !b.neighbourhoods[0].nil? ) 
        @logger.info("neighbourhood:" << b.neighbourhoods[0].neighbourhood.to_s )
        neighbourhoods.push( b.neighbourhoods[0].neighbourhood )
      else
        puts("neighbourhood: is null")
      end
      if ( b.longitude.nil? || b.latitude.nil? )
        address = get_address(b)
        geocode = get_geocode(address)
        @logger.info("longitude:" + geocode.lng.to_s + ",latitude:" + geocode.lat.to_s )
        business = Business.find_by_id(b.id)
        business.longitude = geocode.lng
        business.latitude  = geocode.lat
        business.save
      end
    end
    
    #grab from Yelp
    yelp_businesses = DateIdeas::YelpAdaptor.new(@logger).search(CATEGORIES.fetch(venue_type),neighbourhoods,price_point,page);

    yelp_file = File.new("#{RAILS_ROOT}/data/yelp-data.txt","a")

    yelp_businesses.each do |y|
      yelp_file.puts(y.name.to_s << "," << y.address1.to_s  << "," << y.address2.to_s << "," << y.city << "," << y.province << ","<< y.postal_code << "," << y.country << "," << y.longitude.to_s << "," << y.latitude.to_s )
    end 
    yelp_file.close

    mbusinesses = merge(businesses, yelp_businesses)
    return mbusinesses
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
        @logger.info("======*******************==========")
        @logger.info("business.name:" +b.name.to_s)
        @logger.info("business.longitude:" +b.longitude.to_s)
        @logger.info("business.latitude :" +b.latitude.to_s)
        yelp_businesses.each do |y|
          @logger.info("===>")
          @logger.info("yelp.name:" +y.name.to_s)
          @logger.info("yelp.longitude:" +y.longitude.to_s)
          @logger.info("yelp.latitude :" +y.latitude.to_s)
          @logger.info("y.photo_url" + y.photo_url.to_s)
          #if( b.longitude == y.longitude && b.latitude == y.latitude )
          if( (b.name.eql?(y.name)) || (b.address1.eql?(y.address1)) || (b.longitude == y.longitude && b.latitude == y.latitude) )
            b.photo_url = y.photo_url  
            #merge the reviews
            break
          end
        end
      end
    end
    return businesses
  end
end
