module DatecartsHelper
  # display date cart sorted by venue type
  def sort_by_category(datecart)
    display = ""
    items = datecart.cart_items    
    display_text = { "food" => "Dining", "bars" => "Drinks", "activities_events" => "Activities & Events", "nightlife" => 'Nightlife', 'arts_entertainment' => 'Arts and Entertainment'}
                     
    category_display = Hash.new
    y 'cart items'
    y items
    items.each do |item|
      # only display under the first venue_type that an item is classified under
      # list = item.business.venue_type.split(",")
      # venue = list[0]
      type = item.venue_type
      y type
      y item.business
      y item.event
      venue = item.business
      if venue.nil?
        venue = item.event
        venue_name = venue.title
      else
        venue_name = venue.name
      end
      
      if category_display[type].nil?
        category_display[type] =  "<li>" <<  venue_name << " " << link_to('Remove', datecart_cart_item_path(datecart, item), :method => :delete, :remote => true) << "</li>"
      else
        category_display[type] << " " << "<li>" << venue_name << " " << link_to('Remove', datecart_cart_item_path(datecart, item), :method => :delete, :remote => true) << "</li>"
      end
    end

    category_display.keys.sort.each { |key|
     display << "<p>" << display_text[key] << "</p>" 
     display << "<ul>" << category_display[key] << "</ul>"
    }
    
    display
  end
end
