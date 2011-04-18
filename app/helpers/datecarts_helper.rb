module DatecartsHelper
  # add a helper method here to display date cart sorted by category
  def sort_by_category(datecart)
    # venue = 'food'
    display = ""
  
    category_display = Hash.new
    datecart.cart_items.each do |item|
      biz = item.business
      venue = biz.venue_type
      if category_display[venue].nil?
        category_display[venue] =  "<li>" <<  biz.name << "</li>"
      else
        category_display[venue] << " " << "<li>" <<  biz.name << "</li>"
      end
    end

    category_display.each { |key,value|
      display << "<p>" << key << "</p>" 
      display << "<ul>" << value << "</ul>"
    }
    display
  end
end
