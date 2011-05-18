module BusinessesHelper

  def display_reviews(business)
    html = String.new
    html.concat("<table>")
    if(!business.reviews.nil?)
      business.reviews.each do | review |
        user_review = String.new
        user_info = String.new
        user_info   = "<tr><td><img width='40' height='40' src='%s'/><br/>%s</td><td><img src='%s'/></td></tr>" % [review.user_photo_url_small,review.name, review.rating_img_url ]
        user_review = "<tr><td colspan=\"2\">%s</td></tr>" % [review.text_excerpt ]
        html.concat(user_info).concat(user_review)
      end
    else
      html.concat("<tr><td>No reviews</td</tr>")

    end
    html.concat("</table>")
    return html
  end
end