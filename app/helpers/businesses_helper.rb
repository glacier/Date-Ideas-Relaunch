module BusinessesHelper

  def business_photo business
    business.photo_url
  end
  
  def display_business_hours(business)
    html=""
    if business.hours.nil?
      ""
    else
      raw(business.hours.join("<br/>"))
    end
  end
  
  def display_dateideas_tips
    html = ""
    
    unless @business.dna_excerpt.blank?
      html << '<div id="di_venue_excerpt" class="di_module_large">' 
      html << raw(generate_ribbon_header(:h3, :"dateideas tips", 17)) 
      html << '<div class="di_module_container">' << @business.dna_excerpt << "</div></div>"
	  end
	  
	  raw(html)
  end

  def display_dateideas_reviews
    html = ""
    
    unless @business.reviews.blank?
      html << '<div id="di_reviews" class="di_module_large">'
      html << generate_ribbon_header(:h3, "reviews", 17)
      @business.reviews.each do |r|
        html << html_for_reviews_in_venue(@business.external_id, r)
    	end
      html << '</div>'
    end
    
    raw(html)
  end
  
  def display_review(business)
    html = ""
    if(!business.review.nil?)
      review = business.review
      html_part = ''
        # TODO: Add review count display here
        # TODO: Display price range
      html_part = <<EOF
        <ul class="yelp_review">
          <li><img src="#{review.rating_img_url}" alt="Yelp Rating"></li>
          <li class="review_list_item_excerpt">#{review.text_excerpt}<a href="http://www.yelp.com/biz/#{business.external_id}#hrid:#{review.id}" target="_blank">Read more</a></li>
          <li class="review_list_item_poster">Posted by <a href="http://www.yelp.com/user_details?userid=#{review.user_id}" target="_blank">#{review.name}</a> on <a href="http://www.yelp.com" target="_blank">Yelp.com</a>
          </li>
      </ul>
EOF
      html.concat(html_part)
    end
    html
  end
  
  def html_for_reviews_in_venue(biz_external_id, r)
        # TODO: Add review count display here
        html = <<EOF
        <div class="yelp_review di_module_container">
    			<div class="user_photo"><img src="#{r.user_photo_url_small}" alt="#{r.name}"></div>
    			<div class="review_info">
      			<ul class="yelp_review">
              <li class="review_list_item_excerpt"><img src="#{r.rating_img_url}" alt="Yelp Rating"></li>
              <li>#{r.text_excerpt}<a href="http://www.yelp.com/biz/#{biz_external_id}#hrid:#{r.id}" target="_blank">read more</a></li>
              <li class="review_list_item_poster">Posted by <a href="http://www.yelp.com/user_details?userid=#{r.user_id}" target="_blank">#{r.name}</a> on <a href="http://www.yelp.com" target="_blank">Yelp.com</a></li>
              <li><img src="/images/reviews_from_yelp.gif" %></li>
              </ul>
    			</div>
    		</div>
EOF
  end
end