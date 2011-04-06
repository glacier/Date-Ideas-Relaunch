require 'net/http'
require 'uri'

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
    return perform_request(url)
  end

  # Find a dealer for a parent business
  def find_dealer(pid, uid, page=nil, page_len=nil, lang=nil)
    url = build_url('FindDealer', { 'pid' => pid, 'UID' => uid,
        'pg' => page,  'pgLen' => page_len, 'lang' => lang })
    return perform_request(url)
  end

  # Get details about a business
  def get_business_details(prov, business_name, listing_id, uid, city=nil, lang=nil)
    url = build_url('GetBusinessDetails', {'prov' => prov, 
        'bus-name' => business_name, 'listingId' => listing_id,
        'UID' => uid, 'city' => city, 'lang' => lang})
    return perform_request(url)
  end

  private

  def build_url(method, params)
    params['apikey'] = @api_key
    params['fmt'] = @format
    param_array = Array.new
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
    return resp.body
  end
end

api = YellowAdaptor.new(:apikey=>'hw7hnjkkdqcte54352pyxage', :test_mode => true, :format => 'JSON' )
api.find_business
