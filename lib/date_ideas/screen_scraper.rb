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
end