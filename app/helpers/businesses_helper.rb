module BusinessesHelper
  def business_photo business
    business.photo_url
  end
  
  def display_review(biz_external_id, r)
        # TODO: Add review count display here
        html = <<EOF
        <div class="yelp_review">
    			<div class="user_photo"><img src="#{r.user_photo_url_small}" alt="#{r.name}"></div>
    			<div class="review_info">
      			<ul class="yelp_review">
              <li class="review_list_item_excerpt"><img src="#{r.rating_img_url}" alt="Yelp Rating"></li>
              <li>#{r.text_excerpt}<a href="http://www.yelp.com/biz/#{biz_external_id}#hrid:#{r.id}" target="_blank">read more</a></li>
              <li class="review_list_item_poster">Posted by <a href="http://www.yelp.com/user_details?userid=#{r.user_id}" target="_blank">#{r.name}</a> on <a href="http://www.yelp.com" target="_blank">Yelp.com</a></li>
              </ul>
    			</div>
    		</div>
EOF
  end
end