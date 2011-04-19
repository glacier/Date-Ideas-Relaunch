module DatecartsHelper
  # display date cart sorted by venue type
  def sort_by_category(datecart)
    display = ""
    items = datecart.cart_items      
    category_display = Hash.new
    items.each do |item|
      # only display under the first venue_type that an item is classified under
      # list = item.business.venue_type.split(",")
      # venue = list[0]
      venue = item.venue_type
      biz = item.business
      if category_display[venue].nil?
        category_display[venue] =  "<li>" <<  biz.name << " " << link_to('Remove', datecart_cart_item_path(datecart, item), :method => :delete, :remote => true) << "</li>"
      else
        category_display[venue] << " " << "<li>" << biz.name << " " << link_to('Remove', datecart_cart_item_path(datecart, item), :method => :delete, :remote => true) << "</li>"
      end
    end

    category_display.each { |key,value|
     display << "<p>" << key << "</p>" 
     display << "<ul>" << value << "</ul>"
    }
    
    display
  end
end
