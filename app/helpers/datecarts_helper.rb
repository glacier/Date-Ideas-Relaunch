module DatecartsHelper
  # display date cart sorted by venue type
  def sort_by_category(datecart)
    display = ""
    items = datecart.cart_items
    display_text = {"food" => "Dining", "bars" => "Drinks", "activities_events" => "Activities & Events", "nightlife" => 'Nightlife', 'arts_entertainment' => 'Arts and Entertainment'}

    category_display = Hash.new
    items.each do |item|
      # only display under the first venue_type that an item is classified under
      # list = item.business.venue_type.split(",")
      # venue = list[0]
      venue = item.venue_type
      biz = item.business
      if category_display[venue].nil?
        category_display[venue] = "<li>" << biz.name << " " << link_to('Remove', datecart_cart_item_path(datecart, item), :method => :delete, :remote => true) << "</li>"
      else
        category_display[venue] << " " << "<li>" << biz.name << " " << link_to('Remove', datecart_cart_item_path(datecart, item), :method => :delete, :remote => true) << "</li>"
      end
    end

    category_display.keys.sort.each { |key|
      display << "<p>" << display_text[key] << "</p>"
      display << "<ul>" << category_display[key] << "</ul>"
    }

    display
  end

  def format_yahoo_calendar_link datecart
    # "http://calendar.yahoo.com/?v=60&amp;view=d&amp;type=20&amp;title=Eventful:+NKOTBSB+Tour%3A+New+Kids+On+The+Block+and+Backstreet+Boys&amp;st=20110608T193000&amp;desc=&amp;in_loc=Air+Canada+Centre&amp;in_st=40+Bay+Street&amp;in_csz=Toronto,+ON,+"
    url = "http://calendar.yahoo.com/?v=60&view=d&type=20&"
    name = datecart.name || "My Date"
    hash = {
        :title => "#{name}: i have absolutely no idea what to write here",
        :st => format_time(datecart.datetime),
        :desc => "note",
        :in_loc => "somewhere for now",
        :url => "getdateideas"
    }
    url << hash.to_query
  end

  def format_google_calendar_link datecart

    # google: "http://www.google.com/calendar/event?action=TEMPLATE&amp;dates=20110608T193000/20110608T193000&amp;text=Eventful:+NKOTBSB+Tour%3A+New+Kids+On+The+Block+and+Backstreet+Boys+at+Air+Canada+Centre&amp;location=40+Bay+Street,Toronto,Ontario,Canada&amp;details=&amp;sprop=partner:evdb.com&amp;sprop=partneruuid:E0-001-035309535-0"
    url = "http://www.google.com/calendar/event?action=TEMPLATE&"
    name = datecart.name || "My Date"
    hash = {
        :text => name,
        :dates => format_time(datecart.datetime) << "Z/" << format_time(datecart.datetime+2.hours) << "Z",
        :sprop => "website:www.getdateideas.com&sprop;=name:Get Date Ideas",
        :details => "lots of notes!",
        :location => "figuring this one out",
        :trp => "true"
    }
    url << hash.to_query
  end

  private

  # Format times like this <year><month><day>T<hour><min><sec>
  # Requires zeroes in front of values to distinguish different fields, hence the prepend zero calls
  def format_time time
    return "" unless time
    "#{time.year}#{prepend_zero(time.month)}#{prepend_zero(time.day)}T#{prepend_zero(time.hour)}#{prepend_zero(time.min)}#{prepend_zero(time.sec)}"
  end

  def prepend_zero date
    if date < 10
      return "0#{date}"
    end
    date
  end
end
