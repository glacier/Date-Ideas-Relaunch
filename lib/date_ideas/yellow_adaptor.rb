#!/Users/alviny/.rvm/rubies/ruby-1.9.2-p0/bin/ruby
require 'net/http'
require 'uri'
require 'json'

class YellowAdaptor
  @@PROD_URL = "http://api.yellowapi.com"  
  @@TEST_URL = "http://api.sandbox.yellowapi.com"

  def initialize(api_key, test_mode=false, format="XML")
    @api_key = api_key
    @url = test_mode ? @@TEST_URL : @@PROD_URL
    @format = format
  end


  # Find a business
  def find_business(what, where, uid, page=nil, page_len=nil, sflag=nil, lang=nil)
    url = build_url('FindBusiness', { 'what' => what, 'where' => where,
        'UID' => uid, 'pg' => page, 'pgLen' => page_len,
        'sflag' => sflag, 'lang' => lang })
    return JSON.parse(perform_request(url))
  end

  # Find a dealer for a parent business
  def find_dealer(pid, uid, page=nil, page_len=nil, lang=nil)
    url = build_url('FindDealer', { 'pid' => pid, 'UID' => uid,
        'pg' => page,  'pgLen' => page_len, 'lang' => lang })
    return perform_request(url)
  end

  # Get details about a business
  def get_business_details(prov, business_name, listing_id, uid, city=nil, lang=nil)
    biz_name_encoded = URI.escape(business_name, Regexp.new("[^#{URI::PATTERN::UNRESERVED}]"))
    url = build_url('GetBusinessDetails', {'prov' => prov, 
        'bus-name' => biz_name_encoded, 'listingId' => listing_id,
        'UID' => uid, 'city' => city, 'lang' => lang})
    return perform_request(url)
  end

  def find_biz (what , where = 'default')
    puts "what :" << what.to_s << ", where:" << where.to_s
  end
  def farm()
    #(1..2).each do | page |
      results_hash = find_business('Restaurant','Toronto','216.246.250.183')
      businesses_hash = results_hash.fetch("listings")
      businesses = []

      businesses_hash.each do |b|

        id = b.fetch("id")
        name = b.fetch("name")
        address1 = b.fetch("address").fetch("street")
        city = b.fetch("address").fetch("city")
        province = b.fetch("address").fetch("prov")
        country = "Canada"
        postal_code = b.fetch("address").fetch("pcode")
        sleep 5
        biz_detail = get_business_details(province, name, id, city)
        puts biz_detail.to_s
        break


      end
    #end
  end
  private

  def build_url(method, params)
    params['apikey'] = @api_key
    params['fmt'] = @format
   param_array = []
    params.each_pair do |key, value|
      unless value.nil?
        param_array.push("%s=%s" % [key, value])
      end
    end
    return "%s/%s/?%s" % [@url, method, param_array.join("&")]
  end


  def perform_request(url_string)
    # TODO: handle exceptions /errors
    url = URI.parse(url_string)
    http = Net::HTTP.new(url.host, url.port)
    req = Net::HTTP::Get.new(url.request_uri)
    resp = http.request(req)
    puts resp.body
    return resp.body
  end





end

api = YellowAdaptor.new('hw7hnjkkdqcte54352pyxage', true,  'JSON' )
api.farm()
