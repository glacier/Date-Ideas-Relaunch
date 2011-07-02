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
  def business_detail(business_id)
    consumer = OAuth::Consumer.new(@consumer_key, @consumer_secret, {:site => @url })
    access_token = OAuth::AccessToken.new(consumer, @token, @token_secret)
    path = "/v2/business/" + business_id
    p = access_token.get(path).body
    search_results = JSON.parse(p)
    puts search_results.fetch("reviews").to_s
  end
end

yelp_api = YelpAPI.new('Z720kWRw-CAauOQNUbMEAQ','e7999uMADazHkmG5NDVDWBykczc','1Gj9nSZwzv_o5F_egAYGgYDBsdTdeKFZ','Yd98KQPlSAOWXfmHYsTctbihEH4', 'logger',false)
yelp_api.business_detail('yuzu-sushi-and-sake-bar-toronto')

