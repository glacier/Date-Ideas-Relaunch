class DateIdeas::DnaService

  CATEGORIES = {'food' => ['food', 'restaurants'],
                'bars' => ['bars'],
                'activities_events' => ['active'],
                'nightlife' => ['nightlife'],
                'arts_entertainment' => ['arts'],
  }

  def search(venue_type, location, price_point = 'budget', page = '1', per_page=10, neighbourhood = nil, sub_category = nil)
    puts("DateIdeas.search:" << venue_type.to_s << ":" << location.to_s << ":" << price_point.to_s << ":" << page.to_s)
    neighbourhoods = []
    categories = []
    sql = ''
    if (sub_category.nil? || "all".eql?(sub_category))
      categories = CATEGORIES[venue_type]
    else
      categories.push(sub_category)
    end

    if (neighbourhood.nil? || "all_neighbourhoods".eql?(neighbourhood))
      db_businesses = Business.search_by_district_subsection('Toronto', location, price_point, categories, page)
    else
      db_businesses = Business.search_by_neighbourhood('Toronto', neighbourhood, price_point, categories, page)
    end

    db_businesses_no_excerpt = []

    db_businesses.each do |b|
      if (b.external_id.nil?)
        if (b.longitude.nil? || b.latitude.nil?)
          address = get_address(b)
          geocode = get_geocode(address)
          business = Business.find_by_id(b.id)
          business.longitude = geocode.lng
          business.latitude = geocode.lat
          business.save
        end
        b.neighbourhoods.collect { |hood| neighbourhoods.push(hood.neighbourhood) } #flatten list of neighbourhood objects and add it to the list.
      elsif (b.text_excerpt.nil? || b.text_excerpt.size == 0)
        Rails.logger.info("business with no exerpt :" + b.external_id)
        db_businesses_no_excerpt.push(b)
      end
    end

    Rails.logger.info("neighbourhoods:" + neighbourhoods.to_s)
      #grab from Yelp
    yelp_adaptor = DateIdeas::YelpAdaptorV2.new(false)
    yelp_businesses = yelp_adaptor.search('Toronto', CATEGORIES[venue_type], neighbourhoods)

    merged_businesses = merge(db_businesses, yelp_businesses)

      #search business details
    merged_businesses.each do |b|
      if (!b.external_id.nil? && (b.dna_excerpt.nil? ||b.dna_excerpt.size == 0))
        business_detail = yelp_adaptor.business_detail(b.external_id)
        if (!business_detail.nil?)
          highest_review = Review.new
          highest_review.rating = 0
          business_detail.reviews.each do |biz_review|
            if (biz_review.rating > highest_review.rating)
              highest_review = biz_review
            end
          end

          b.review = highest_review
        end
      end
    end
    return merged_businesses
  end

  def get_geocode(address)
    puts('starting geocoder call for address: '+address)
    result = Geokit::Geocoders::MultiGeocoder.geocode(address)
    Rails.logger.info("result"<<result.to_s)
    return result
  end

  def get_address(business)
    address = ''
    address.concat(business.address1)

    if !(business.address2.nil? || business.address2.empty?)
      address.concat(", ").concat(business.address2)
    end

    if !(business.address3.nil? || business.address3.empty?)
      address.concat(", ").concat(business.address3)
    end

    if !(business.city.nil? || business.city.empty?)
      address.concat(", ").concat(business.city)
    end

    if !(business.province.nil? || business.province.empty?)
      address.concat(", ").concat(business.province)
    end
    if !(business.country.nil? || business.country.empty?)
      address.concat(", ").concat(business.country)
    end
    return address
  end

  def merge(businesses, yelp_businesses)
    if (!yelp_businesses.nil?)
      businesses.each do |b|
        if (b.external_id.nil?)
          yelp_businesses.each do |y|
            if ((b.name.eql?(y.name) && b.address1.eql?(y.address1)) || (b.name.eql?(y.name) && b.longitude == y.longitude && b.latitude == y.latitude))
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
