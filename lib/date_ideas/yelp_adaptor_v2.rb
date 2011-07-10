class DateIdeas::YelpAdaptorV2
  @@PROD_URL = "http://api.yelp.com"
  @@TEST_URL = "http://api.sandbox.yelp.com"
  @@CONSUMER_KEY = 'Z720kWRw-CAauOQNUbMEAQ'
  @@CONSUMER_SECRET = 'e7999uMADazHkmG5NDVDWBykczc'
  # @@TOKEN = '1Gj9nSZwzv_o5F_egAYGgYDBsdTdeKFZ'
  # @@TOKEN_SECRET = 'Yd98KQPlSAOWXfmHYsTctbihEH4'
  @@TOKEN = 'PVQ8f1oAcFIal8fDodOx7qW5VXNwbhkK'
  @@TOKEN_SECRET = 'WdUPWAiYOfViusLJXxaXDeeTVO0'
  
  def initialize(logger, test_mode = false)
    @logger = logger
    @url = test_mode ? @@TEST_URL : @@PROD_URL
    @consumer = OAuth::Consumer.new(@@CONSUMER_KEY, @@CONSUMER_SECRET, {:site => @url})
    @access_token = OAuth::AccessToken.new(@consumer, @@TOKEN, @@TOKEN_SECRET)
  end

  def business_detail(business_id)
    begin
      path = "/v2/business/" + business_id
      result = @access_token.get(path).body
      search_results = JSON.parse(result)
      if (search_results.has_key?("error"))
        business = nil
        error_message = search_results.fetch("error").fetch("text")
        @logger.error("Yelp Server Error Message :" +error_message)
      else
        business = create_business(search_results, true)
      end
    rescue Exception => e
      Rails.logger.error "YELP ADAPTOR ERROR: #{__LINE__}: #{e.message}"
      return nil
    end
    business
  end

  def search(location, categories, neighbourhoods, offset = 0)
    returned_businesses = []
    if (!neighbourhoods.nil? && neighbourhoods.size > 0)
      neighbourhoods.each do |n|
        if (!n.nil?)
          neighbourhood = n.gsub(/[ ]/, '+')
          path="/v2/search?term=%s&location=%s+%s&offset=%s" % [categories.join("+"), CGI.escape(neighbourhood), CGI.escape(location), offset]
          puts path
          result = @access_token.get(path).body
          search_results = JSON.parse(result)

          if (search_results.has_key?("businesses"))
            businesses_hash = search_results.fetch("businesses")
            r_businesses = create_businesses(businesses_hash)
            r_businesses.each do |biz|
              returned_businesses.push(biz)
            end
          else
            #handle errors
            error_message = search_results.fetch("error").fetch("text")
            @logger.error("Yelp Server Error Message: " << error_message)
          end
        end
      end
    else
      path="/v2/search?term=%s&location=%s&offset=%s" % [categories.join("+"), CGI.escape(location), offset]
      puts path
      result = @access_token.get(path).body
      search_results = JSON.parse(result)
      if (search_results.has_key?("businesses"))
        businesses_hash = search_results.fetch("businesses")
        returned_businesses = create_businesses(businesses_hash)
      else
        error_message = search_results.fetch("error").fetch("text")
        @logger.error("Yelp Server Error Message2: " +error_message)
      end
    end
    return returned_businesses
  end

  def create_businesses(businesses_hash)
    businesses = []
    businesses_hash.each do |business_hash|
      business = create_business(business_hash)
      businesses.push(business)
    end
    return businesses
  end

  def create_business(business_hash, extract_reviews = false)
    business = Business.new
    if (business_hash.has_key?("id"))
      business.external_id = business_hash.fetch("id")
    end
    business.name = business_hash.fetch("name")
    address = business_hash.fetch("location").fetch("address")
    business.address1 = address[0]
    if (address.size == 2)
      business.address2 = address[1]
    end
    if (address.size == 3)
      business.address3 = address[2]
    end
    if (business.city = business_hash.fetch("location").has_key?("city"))
      business.city = business_hash.fetch("location").fetch("city")
    end
    if (business_hash.fetch("location").has_key?("state_code"))
      business.province = business_hash.fetch("location").fetch("state_code")
    end
    if (business_hash.fetch("location").has_key?("postal_code"))
      business.postal_code = business_hash.fetch("location").fetch("postal_code")
    end
    if (business_hash.fetch("location").has_key?("country_code"))
      business.country = business_hash.fetch("location").fetch("country_code")
    end
    if (business_hash.has_key?("image_url"))
      business.photo_url = business_hash.fetch("image_url")
    end
    if (business_hash.has_key?("phone"))
      business.phone_no = business_hash.fetch("phone")
    end
    if (business_hash.fetch("location").has_key?("coordinate"))
      business.longitude = business_hash.fetch("location").fetch("coordinate").fetch("longitude")
      business.latitude = business_hash.fetch("location").fetch("coordinate").fetch("latitude")
    end
    if (business_hash.has_key?("url"))
      business.url = business_hash.fetch("url")
    end
    if (extract_reviews)
      business.reviews = create_reviews(business_hash.fetch("reviews"))
    end
    if (business_hash.has_key?("categories"))
      business.categories = create_categories(business_hash.fetch("categories"))
    end
    if (business_hash.fetch("location").has_key?("neighborhoods"))
      business.neighbourhoods = create_neighbourhoods(business_hash.fetch("location").fetch("neighborhoods"))
    end
    return business
  end

  def create_reviews(reviews_hash)
    reviews = []
    reviews_hash.each { |review_hash|
      reviews.push(create_review(review_hash))
    }
    return reviews
  end

  def create_review(review_hash)
    review = Review.new
    review.rating = review_hash.fetch("rating")
    review.text_excerpt = review_hash.fetch("excerpt")
    review.id = review_hash.fetch("id")
    if (review_hash.has_key?('rating_image_url'))
      review.rating_img_url = review_hash.fetch('rating_image_url')
    end
      #review.rating_img_url = review_hash.fetch("rating_img_url")
    review.rating_img_url_small = review_hash.fetch("rating_image_small_url")

    if (review_hash.has_key?("user"))
      if (review_hash.fetch("user").has_key?("image_url"))
        review.user_photo_url_small = review_hash.fetch("user").fetch("image_url")
      end
      if (review_hash.fetch("user").has_key?("id"))
        review.user_id = review_hash.fetch("user").fetch("id")
      end
      if (review_hash.fetch('user').has_key?('name'))
        review.name = review_hash.fetch('user').fetch('name')
      end
    end

    return review
  end

  def create_neighbourhoods(neighbourhoods_hash)
    neighbourhoods = []
    neighbourhoods_hash.each do |n|
      neighbourhood = Neighbourhood.new
      neighbourhood.neighbourhood = n
      neighbourhoods.push(neighbourhood)
    end
    return neighbourhoods
  end

  def create_categories(categories_hash)
    categories = []
    categories_hash.each do |display_name, name|
      category = Category.new
      category.name = name
      category.display_name = display_name
      categories.push(category)
    end
    return categories
  end
end

