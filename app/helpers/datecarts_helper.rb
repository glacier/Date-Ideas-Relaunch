module DatecartsHelper
  # display date cart sorted by venue type
  def sort_by_category(datecart)
    display = ""
    items = datecart.cart_items    
    display_text = { "food" => "Dining", "bars" => "Drinks", "activities_events" => "Activities & Events", "nightlife" => 'Nightlife', 'arts_entertainment' => 'Arts and Entertainment'}
                     
    category_display = Hash.new
    items.each do |item|
      # only display under the first venue_type that an item is classified under
      html_str = "<tr><td>"
      type = item.venue_type
      venue = item.business
      if venue.blank?
        venue = item.event
        venue_name = venue.title
        html_str << link_to(venue_name, venue.url)
      else
        venue_name = venue.name
        html_str << link_to(venue_name, business_path(venue))
      end
              
      html_str = html_str<< "</td><td>" << link_to(content_tag(:span, "", :class => 'ui-icon ui-icon-trash'), datecart_cart_item_path(datecart, item), :method => :delete, :remote => true) << "</td></tr>"
      
      if category_display[type].nil?
        category_display[type] = html_str
      else
        category_display[type] << " " << html_str
      end
    end

    category_display.keys.sort.each { |key|
     display << "<p>" << display_text[key] << "</p>" 
     display << "<table>" << category_display[key] << "</table>"
    }
    
    display
  end
end
