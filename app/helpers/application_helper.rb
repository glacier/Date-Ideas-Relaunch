module ApplicationHelper
  include WizardHelper
  include DashboardHelper
  def get_display_text(venue)
    display_text = { "food" => "Dining", 
                    "bars" => "Drinks", 
                    "activities_events" => "Activities & Events", 
                    "nightlife" => 'Nightlife', 
                    "arts_entertainment" => "Arts and Entertainment"
                    }
      
    display_text[venue]
  end
  
  # Use this function in views to dynamically set the page title
  def title(page_title = nil)
    if page_title
      content_for(:title) do
        page_title
      end
    else
      content_for(:title) do
        "DateIdeas.ca"
      end
    end
  end

  def generate_unordered_list items
    html = "<ul>"
    items.each do |item|
      unless item.blank?
        html << "<li>" << item << "</li>"
      end
    end
    html << "</ul>"
    
    raw(html)
  end
  
  # implemented according to railscast episode 244
  def avatar_url(user)
    default_url = "#{root_url}images/guest.jpg"
    # BUG: Don't use gravatar as you can get someone else's gravatar with your name.
    # eg.  Try signing up with name "test meme" ... it's some dude's distorted face
    # if user.profile
    #      if user.profile.avatar_url.present?
    #        user.profile.avatar_url
    #      else
    #        gravatar_id = Digest::MD5.hexdigest(user.email.downcase)
    #        "http://gravatar.com/avatar/#{gravatar_id}?s=200&d=#{CGI.escape(default_url)}"
    #      end
    #    else
    #      default_url
    #    end
  end

  def image_url(thing, url)
    default_url = "#{root_url}images/#{thing}_placeholder.jpg"
    if url.nil?
      return default_url
    else
      return url
    end
  end

  def display_time(start_time, end_time)
    if end_time.blank?
      return start_time
    else
      return "From " + start_time + " to " + end_time
    end
  end

  # builds an eventful.com uri request
  # eg. http://eventful.com/toronto/events?q=music+and+food&t=Next+7+days&sort_order=Popularity
  def eventful_url(location, venue_type, time, sorting)
    params = {
        "c" => Event.EVENT_CATEGORY.fetch(venue_type),
        "t" => time,
        "sort_order" => sorting
    }
    query_params = params.collect { |k, v| "#{k}=#{v}" }
    query = query_params.join("&")
    uri = URI::HTTP.build([nil, "eventful.com", nil, "/" + location + "/" + "events", query, nil]).to_s
    uri.to_s
  end
  
  def generate_ribbon_header h_tag, title, span_size
    result = content_tag(h_tag, content_tag(:span, title), :class=>"span-#{span_size}")
    result << content_tag(:div, '', :class=>'di_module_header_tail')
    content_tag(:div, :class=>"ribbon_header") do
      result
    end
  end
  
  def generate_header h_tag, title, span_size
    result = content_tag(h_tag, content_tag(:span, title), :class=>"span-#{span_size}")
    content_tag(:div, :class=>"header") do
      result
    end
  end
  
  # Use the previous modal dialogue format to keep things DRY
  # pass in the title of the dialogue, the div where things will be opened, and the partial of content to render
  def generate_modal_dialogue div, title, partial
    <<-MODAL
    //define config object
var dialogOpts = {
	//title: \"#{title}\",
	modal: true,
	// overlay: {
	//	background: "url(img/modal.png) repeat"
	//},
	// buttons: {
	// 	"Ok": function() { $(this).dialog("close"); }
	// },
	//width: 650,
	closeOnEscape: true,
	autoOpen: false,
	resizable: false,
	draggable: false,
	position: top,
	stack: true,
	open: function() {
		//display correct dialog content
		$("##{div}").html("#{escape_javascript partial}");
	}
};

$("##{div}").dialog(dialogOpts);
$("##{div}").removeClass('ui-dialog-content');
$("##{div}").dialog("open");

    MODAL
  end

  def format_datetime *args
    return "" if args.blank?
    options = args.extract_options!
    datetime = args.shift

    return "" unless datetime
    # Make this modular, we may want to keep customizing it for other purposes later
    if options[:past]
      datetime.to_formatted_s(:long_ordinal_past)
    else
      datetime.to_formatted_s(:long_ordinal) #Formats as June 11th, 2011 hh:mm (handles timezones)
    end
  end

  # Generate the html for a static map from google. Uses format helpers to tailor the api call
  def generate_map datecart
    image_tag "https://maps.google.com/maps/api/staticmap?#{format_google_maps_api_call_parameters(datecart.cart_items)}", :class => "map", :alt => "Date Map"
  end

  def generate_map_single cart_item
    image_tag "https://maps.google.com/maps/api/staticmap?#{format_google_maps_api_call_parameters([cart_item])}", :class => "map", :alt => "Date Map"
  end

  private

  # Generate the query hash for the api call to generate a static map
  def format_google_maps_api_call_parameters cart_items
    parameters = {
        :size => ParamFile.new.google_maps_static_api_dimensions,
        :sensor => false
    }
    result = ""
    result << parameters.to_query
    result << "&#{format_google_maps_markers(cart_items)}" # Add the marker CGI params
  end
  
  #TODO: Update this to use the new naming system for locations once they are sortable
  def format_google_maps_markers cart_items
    markers = ""
    cart_items.each do |cart_item|
      if cart_item.business_id
        business = cart_item.business
        markers << "markers=color:blue|label:#{business.name}|#{business.address1},#{business.city},#{business.province},#{business.postal_code},#{business.country}&"
      else
        event = cart_item.event
        markers << "markers=color:blue|label:#{event.title}|#{event.venue_address},#{event.city_name},#{event.postal_code}&"
      end
    end
    markers
  end

end
