require 'open-uri'

class DateIdeas::ScreenScraper

  PRICE_RANGE = { '$'    => '< $10',
                  '$$'   => '$10-$25',
                  '$$$'  => '$25-$50',
                  '$$$$' => '$50+',
                }
  def initialize(logger)
    @logger = logger
  end
  def get_price_range(biz)
    url = 'http://www.yelp.ca/biz/'
    price = String.new

    begin
      url = url.concat(biz)
      @logger.info("url:" +url)
      doc = Nokogiri::HTML(open(url))
      price_range = doc.xpath('//a[@id="price_tip"]/text()').to_s
      price = PRICE_RANGE[price_range]
    rescue Exception => msg
      @logger.error("Exception:" +msg.to_s)
    end
    return price
  end
  def get_business_details(biz_external_id)
    url = 'http://www.yelp.ca/biz/'
    price = String.new
    hash_result = Hash.new
    begin
      url = url.concat(biz_external_id)
      @logger.info("url:" +url)
      doc = Nokogiri::HTML(open(url))
      price_range = doc.xpath('//a[@id="price_tip"]/text()').to_s
      hours = Array.new
      delim = String.new
      hours_nodes = doc.xpath('//p[@class="hours"]/text()')
      hours_nodes.each do | h |
        hours.push(h.to_s)
      end
      group_date_friendly = doc.xpath('//dd[@class="attr-RestaurantsGoodForGroups"]/text()').to_s
      dress_code = doc.xpath('//dd[@class="attr-RestaurantsAttire"]/text()').to_s
      takes_reservations = doc.xpath('//dd[@class="attr-RestaurantsReservations"]/text()').to_s
      kids_friendly = doc.xpath('//dd[@class="attr-GoodForKids"]/text()').to_s
      price = PRICE_RANGE[price_range]
      hash_result['price'] = price
      hash_result['hours'] = hours
      hash_result['group_date_friendly'] = group_date_friendly
      hash_result['dress_code'] = dress_code
      hash_result['takes_reservations'] = takes_reservations
      hash_result['kids_friendly'] = kids_friendly
    rescue Exception => msg
      @logger.error("Exception:" +msg.to_s)
      hash_result = nil
    end
    return hash_result
  end
end
