module DatecartsHelper
  # display date cart sorted by venue type
  def sort_by_category(datecart)
    display = ""
    items = datecart.cart_items    
    display_text = { "food" => "Dining", "bars" => "Drinks", "activities_events" => "Activities & Events", "nightlife" => 'Nightlife', 'arts_entertainment' => 'Arts and Entertainment'}
                     
    category_display = Hash.new
    items.each do |item|
      # only display under the first venue_type that an item is classified under
      type = item.venue_type
      venue = item.business
      if venue.nil?
        venue = item.event
        venue_name = venue.title
      else
        venue_name = venue.name
      end
      
      html_str = "<li>" <<  venue_name << " " << link_to('Remove', datecart_cart_item_path(datecart, item), :method => :delete, :remote => true) << "</li>"
      if category_display[type].nil?
        category_display[type] = html_str
      else
        category_display[type] << " " << html_str
      end
    end

    category_display.keys.sort.each { |key|
     display << "<p>" << display_text[key] << "</p>" 
     display << "<ul>" << category_display[key] << "</ul>"
    }
    
    display
  end
end
