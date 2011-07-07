module BusinessesHelper

  def display_reviews(business)
    html = ''
    if (!business.reviews.nil?)
      business.reviews.each do |review|
        html_part = ''
        html_part = <<EOF
        <ul class="yelp_review">
          <li class="review_list_item_profile">
            <img src="#{review.user_photo_url_small}" alt="#{review.name}">
          </li>
          <li class="review_list_item_excerpt"><img src="#{review.rating_img_url}" alt="Yelp Rating"><br>#{review.text_excerpt}<a href="http://www.yelp.com/biz/#{business.external_id}#hrid:#{review.id}" target="_blank">read more</a>.</li>
          <li class="review_list_item_poster">Posted by <a href="http://www.yelp.com/user_details?userid=#{review.user_id}" target="_blank">#{review.name}</a> on <a href="http://www.yelp.com" target="_blank">Yelp.com</a>
          </li>
      </ul>
EOF
        html.concat(html_part)
      end

    end
    html
  end

  def display_review(business)
    html = ''

    if (!business.review.nil?)
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
end