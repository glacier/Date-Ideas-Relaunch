class DateIdeas::YelpAdaptorV2
  @@PROD_URL = "http://api.yelp.com"
  @@TEST_URL = "http://api.sandbox.yelp.com"
  def initialize(consumer_key, consumer_secret, token, token_secret, logger, test_mode = false )
    @consumer_key = consumer_key
    @consumer_secret = consumer_secret
    @token = token
    @token_secret = token_secret
    @logger = logger
    @url = test_mode ? @@TEST_URL : @@PROD_URL
  end
  def business_detail(business_id)
    consumer = OAuth::Consumer.new(@consumer_key, @consumer_secret, {:site => @url })
    access_token = OAuth::AccessToken.new(consumer, @token, @token_secret)
    path = "/v2/business/" + business_id
    p = access_token.get(path).body
    search_results = JSON.parse(p)
    business = create_business(search_results)
    return business
  end
  def search(location, categories, neighbourhoods, offset = 0)
    puts "Yelp Adaptor Version 2"
    consumer = OAuth::Consumer.new(@consumer_key, @consumer_secret, {:site => @url })
    access_token = OAuth::AccessToken.new(consumer, @token, @token_secret)
    returned_businesses = Array.new
    neighbourhoods.each do | n |
      neighbourhood = n.gsub(/[ ]/,'+')
      path="/v2/search?term=%s&location=%s+%s&offset=%s" % [categories.join("+"), neighbourhood, location, offset]
      p = access_token.get(path).body
      search_results = JSON.parse(p)
      businesses_hash = search_results.fetch("businesses")
      r_businesses = Array.new
      r_businesses = create_businesses(businesses_hash)
      r_businesses.each do |biz|
        returned_businesses.push( biz )
      end
    end

    return returned_businesses
  end
  def create_businesses(businesses_hash)
    businesses = Array.new
    businesses_hash.each do |business_hash|
      business = create_business(business_hash)
      businesses.push(business)
    end
    return businesses
  end
  def create_business(business_hash)
    business = Business.new
    business.external_id = business_hash.fetch("id")
    business.name = business_hash.fetch("name")
    address = business_hash.fetch("location").fetch("address")
    business.address1 = address[0]
    if( address.size == 2 )
      business.address2 = address[1]
    end
    if( address.size == 3 )
      business.address3 = address[2]
    end
    business.city = business_hash.fetch("location").fetch("city")
    business.province = business_hash.fetch("location").fetch("state_code")
    business.postal_code = business_hash.fetch("location").fetch("postal_code")
    business.country = business_hash.fetch("location").fetch("country_code")
    if(business_hash.has_key?("image_url"))
      business.photo_url = business_hash.fetch("image_url")
    end
#    business.distance = business_hash.fetch("distance")
    if( business_hash.has_key?("phone"))
      business.phone_no = business_hash.fetch("phone")
    end
    business.text_excerpt = "Some restaurant description...blah blah blah."#business_hash.fetch("text_excerpt")
    business.longitude = business_hash.fetch("location").fetch("coordinate").fetch("longitude")
    business.latitude = business_hash.fetch("location").fetch("coordinate").fetch("latitude")
    business.url = business_hash.fetch("url")
#    business.reviews = create_reviews(business_hash.fetch("reviews"))
    business.categories = create_categories(business_hash.fetch("categories"))
    if(business_hash.fetch("location").has_key?("neighborhoods"))
      business.neighbourhoods = create_neighbourhoods(business_hash.fetch("location").fetch("neighborhoods"))
    end
    @logger.info("business:" + business.name )
    return business
  end
  def create_reviews(reviews_hash)
    reviews = Array.new
    reviews_hash.each{ |review_hash|
      reviews.push(create_review(review_hash))
    }
    return reviews
  end
  def create_review(review_hash)
    review = Review.new
    review.id = review_hash.fetch("id")
    review.text_excerpt = review_hash.fetch("text_excerpt")
    review.rating_img_url = review_hash.fetch("rating_img_url")
    review.rating_img_url_small = review_hash.fetch("rating_img_url_small")
    return review
  end
  def create_neighbourhoods(neighbourhoods_hash)
    neighbourhoods = Array.new
    neighbourhoods_hash.each do |n|
      neighbourhood = Neighbourhood.new
      neighbourhood.neighbourhood = n
      neighbourhoods.push(neighbourhood)
      @logger.info("neighbourhood:" + n )
    end
    return neighbourhoods
  end
  def create_categories(categories_hash)
    categories = Array.new
    categories_hash.each do |display_name, name |
      category = Category.new
      category.name = name
      category.display_name = display_name
      categories.push(category)
      @logger.info("category:" +name )
    end
    return categories
  end
end

