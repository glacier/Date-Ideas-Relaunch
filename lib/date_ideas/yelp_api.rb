require 'rubygems'
require 'oauth'
require 'json'

class YelpAPI
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
  def search_business(location, categories, neighbourhoods)
    consumer = OAuth::Consumer.new(@consumer_key, @consumer_secret, {:site => @url })
    access_token = OAuth::AccessToken.new(consumer, @token, @token_secret)
    neighbourhood_index = rand(neighbourhoods.length)
    neighbourhood = neighbourhoods[neighbourhood_index].gsub(/[ ]/,'+')

    path="/v2/search?term=%s&location=%s,%s" % [categories.join("+"), neighbourhood, location]
    puts path
    p=access_token.get(path).body
    puts p.to_s
    search_results = JSON.parse(p)
    businesses_hash = search_results.fetch("businesses")
    puts "number of business:"<< businesses_hash.length
    businesses_hash.each do |biz |
      puts "--------------------"
      puts biz.fetch("id")
      puts biz.fetch("name")
      puts biz.fetch("location").fetch("address")
      puts biz.fetch("categories")
      if( biz.fetch("location").has_key?("neighborhoods") )
        puts biz.fetch("location").fetch("neighborhoods")
      else
        puts "no neighborhoods"
      end
    end

  end
  def create_business(business_hash)
    business = Business.new
    business.id = business_hash.fetch("id")
    business.address1 = business_hash.fetch("address1")
    business.address2 = business_hash.fetch("address2")
    business.address3 = business_hash.fetch("address3")
    business.name = business_hash.fetch("name")
    business.city = business_hash.fetch("city")
    business.province = business_hash.fetch("state")
    business.postal_code = business_hash.fetch("zip")
    business.country = business_hash.fetch("country")
    business.photo_url = business_hash.fetch("photo_url")
    business.distance = business_hash.fetch("distance")
    business.phone_no = business_hash.fetch("phone")
    business.text_excerpt = "Some restaurant description...blah blah blah."#business_hash.fetch("text_excerpt")
    business.avg_rating = business_hash.fetch("avg_rating")
    business.rating_img_url = business_hash.fetch("rating_img_url")
    business.longitude = business_hash.fetch("longitude")
    business.latitude = business_hash.fetch("latitude")
    business.url = business_hash.fetch("url")
    business.reviews = create_reviews(business_hash.fetch("reviews"))
    business.categories = create_categories(business_hash.fetch("categories"))
    business.neighbourhoods = create_neighbourhoods(business_hash.fetch("neighborhoods"))
    @logger.info("business:" + business_hash.to_s )
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
      neighbourhood.neighbourhood = n.fetch("name")
      neighbourhoods.push(neighbourhood)
    end
    return neighbourhoods
  end
  def create_categories(categories_hash)
    categories = Array.new
    categories_hash.each do |c|
      category = Category.new
      category.name = c.fetch("category_filter")
      categories.push(category)
    end
    return categories
  end
end

yelp_api = YelpAPI.new('Z720kWRw-CAauOQNUbMEAQ','e7999uMADazHkmG5NDVDWBykczc','1Gj9nSZwzv_o5F_egAYGgYDBsdTdeKFZ','Yd98KQPlSAOWXfmHYsTctbihEH4', 'logger',false)
yelp_api.search_business('Toronto',['restaurants','food'], ['The Annex'])

