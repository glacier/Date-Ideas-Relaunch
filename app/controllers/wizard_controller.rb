class WizardController < ApplicationController
  # before_filter :authenticate_user!

  def index
    @wizard = Wizard.new
  end
  def show
    @wizard = Wizard.new
  end
  def create
    @wizard = Wizard.new(params[:venue], params[:location],params[:price_point])
    @marker_counter = 0
    #client = Yelp::Client.new
    #request = Yelp::Review::Request::Location.new(
    #              :address => '365 Bartlett Ave.',
    #              :city => 'Toronto',
    #              :state => 'ON',
    #              :radius => 10,
    #              :term => 'restaurant',
    #             :yws_id => '9VeDRJ1tPeDsdRUAkZAukA')
    #response = client.search(request)
    #@wizard.response = response
    #hardcode yelp response for now.
    
    #businesses_hash = response.fetch("businesses")
    #bsort(create_businesses(businesses_hash))
    
    #grab businesses from db, not yelp
    businesses = Business.all
    @datecart = current_cart
    
    #businesses.sort {|x,y| x.avg_rating <=> y.avg_rating }
    @wizard.businesses = businesses
    @wizard.restaurant = businesses[0]
    @wizard.activity = businesses[1]
    @wizard.dessert = businesses[2]

    #google map thingy
    @map = Cartographer::Gmap.new( 'map' )
    @map.zoom = :bound

    icon_building = Cartographer::Gicon.new(:name => "building_icon",
            :image_url => 'http://chart.apis.google.com/chart?chst=d_map_pin_icon&chld=glyphish_heart|C80000',
            :shadow_url => 'http://chart.apis.google.com/chart?chst=d_map_pin_shadow',
            :anchor_x => 6,
            :anchor_y => 20)
    @map.icons << icon_building

    add_marker(@map,icon_building,businesses[0] )
    add_marker(@map,icon_building,businesses[1] )
    add_marker(@map,icon_building,businesses[2] )

    #respond_with(@wizard)

    respond_to do |format|
        format.html { render :action =>"show" }
    end
  end
  def add_marker(map, icon, business)
    @marker_counter = @marker_counter + 1
    #create a position
    position = Array.new
    position << business.latitude
    position << business.longitude
    
    name = "marker" << @marker_counter.to_s
    
    url = business.url
    # logger.info("name:" << name)
    # logger.info("url:" << url)
    marker = Cartographer::Gmarker.new(:name=> name, 
            :marker_type => "Building",
            :position => position,
            :info_window => "<h1>#{business.name}</h1>",
            :icon => icon)
            
    map.markers << marker         
  end
  def create_businesses(businesses_hash)
    businesses = Array.new
    businesses_hash.each do |business_hash|
      business = create_business(business_hash)
      businesses.push(business)
    end
    return businesses
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
    key = String.new
    key = "map_" <<  business.id 
    map = Cartographer::Gmap.new( key )
    map.zoom = :bound

    icon_building = Cartographer::Gicon.new(:name => "building_icon",
            :image_url => 'http://chart.apis.google.com/chart?chst=d_map_pin_icon&chld=glyphish_heart|C80000',
            :shadow_url => 'http://chart.apis.google.com/chart?chst=d_map_pin_shadow',
            :anchor_x => 6,
            :anchor_y => 20)
    map.icons << icon_building
    
    add_marker(map, icon_building, business)
    
    business.map = map
    #logger.info("business hash:" << business_hash.to_s )
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
  def bsort(list)

    slist = list.clone

    for i in 0..(slist.length - 1)
      for j in 0..(slist.length - i - 2)
        if ( slist[j].avg_rating <=> slist[j+1].avg_rating ) == -1
          slist[j], slist[j + 1] = slist[j + 1], slist[j]
        end
      end
    end

    return slist
  end
end
