class DateIdeas::YelpAdaptor

  def search(venue_type, neighbourhood, price_point = 'price_point', page = 'page')
    Rails.logger.info("yelp:venue_type:" + venue_type.to_s)
    Rails.logger.info("yelp:neighbourhood:" + neighbourhood.to_s)
    client = Yelp::Client.new
    request = Yelp::Review::Request::Location.new(
        :neighborhood => neighbourhood[1],
        :city => 'Toronto',
        :state => 'ON',
        :term => venue_type,
        :yws_id => '9VeDRJ1tPeDsdRUAkZAukA')
    response = client.search(request)
    businesses_hash = response.fetch("businesses")
    businesses = bsort(create_businesses(businesses_hash))
    return businesses
  end

  def bsort(list)
    slist = list.clone
    for i in 0..(slist.length - 1)
      for j in 0..(slist.length - i - 2)
        if (slist[j].avg_rating <=> slist[j+1].avg_rating) == -1
          slist[j], slist[j + 1] = slist[j + 1], slist[j]
        end
      end
    end

    slist
  end

  def create_businesses(businesses_hash)
    businesses = []
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
    business.text_excerpt = "Some restaurant description...blah blah blah." #business_hash.fetch("text_excerpt")
    business.avg_rating = business_hash.fetch("avg_rating")
    business.rating_img_url = business_hash.fetch("rating_img_url")
    business.longitude = business_hash.fetch("longitude")
    business.latitude = business_hash.fetch("latitude")
    business.url = business_hash.fetch("url")
    business.reviews = create_reviews(business_hash.fetch("reviews"))
    business.categories = create_categories(business_hash.fetch("categories"))
    business.neighbourhoods = create_neighbourhoods(business_hash.fetch("neighborhoods"))
    Rails.logger.info("business:" + business_hash.to_s)
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
    review.id = review_hash.fetch("id")
    review.text_excerpt = review_hash.fetch("text_excerpt")
    review.rating_img_url = review_hash.fetch("rating_img_url")
    review.rating_img_url_small = review_hash.fetch("rating_img_url_small")
    return review
  end

  def create_neighbourhoods(neighbourhoods_hash)
    neighbourhoods = []
    neighbourhoods_hash.each do |n|
      neighbourhood = Neighbourhood.new
      neighbourhood.neighbourhood = n.fetch("name")
      neighbourhoods.push(neighbourhood)
    end
    return neighbourhoods
  end

  def create_categories(categories_hash)
    categories = []
    categories_hash.each do |c|
      category = Category.new
      category.name = c.fetch("category_filter")
      categories.push(category)
    end
    return categories
  end
end
