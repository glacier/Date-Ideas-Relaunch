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
  def search_business()
    consumer = OAuth::Consumer.new(@consumer_key, @consumer_secret, {:site => @url })
    access_token = OAuth::AccessToken.new(consumer, @token, @token_secret)
    path = "/v2/search?location=toronto"
    p=access_token.get(path).body

  end
end

yelp_api = new YelpAPI('Z720kWRw-CAauOQNUbMEAQ','e7999uMADazHkmG5NDVDWBykczc','1Gj9nSZwzv_o5F_egAYGgYDBsdTdeKFZ','Yd98KQPlSAOWXfmHYsTctbihEH4',nil,false)
yelp_api.search_business()