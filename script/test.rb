# coding: utf-8
require 'rubygems'
require 'oauth'

api_host= 'http://api.yelp.com'
consumer_key = 'Z720kWRw-CAauOQNUbMEAQ'
consumer_secret = 'e7999uMADazHkmG5NDVDWBykczc'
token = 'PVQ8f1oAcFIal8fDodOx7qW5VXNwbhkK'
token_secret = 'WdUPWAiYOfViusLJXxaXDeeTVO0'



api_host = 'api.yelp.com'

consumer = OAuth::Consumer.new(consumer_key, consumer_secret, {:site => "http://#{api_host}"})
access_token = OAuth::AccessToken.new(consumer, token, token_secret)

path = "/v2/search?term=food+restaurants&location=H3H+1A2+%s+QC+Canada" % [CGI.escape('Montréal')]
p path
p access_token.get(path).body
