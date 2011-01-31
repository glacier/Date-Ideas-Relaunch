module WizardHelper
  def display(business)
    display = ""
    display << business.name
    if ! ( business.photo_url.nil? || business.photo_url.empty? )
      display << "<img src=\"" << business.photo_url << "/>"
    end

    display << display_address(business)
    return display
  end
  def display_address(business)
      bus_addr = String.new

      bus_addr.concat(business.address1)

      if ! (business.address2.nil? || business.address2.empty?)

        bus_addr.concat(", ").concat(business.address2)
      end

      if ! (business.address3.nil? || business.address3.empty?)
        bus_addr.concat(", ").concat(business.address3)
      end

      if ! (business.city.nil? ||   business.city.empty?)
        bus_addr.concat(", ").concat(business.city)
      end

      if ! (business.province.nil? || business.province.empty?)
        bus_addr.concat(", ").concat(business.province)
      end

      if ! (business.phone_no.nil? || business.phone_no.empty?)
        bus_addr.concat(" (").concat(business.phone_no[0..2]).concat(")").concat(business.phone_no[3..5]).concat("-").concat(business.phone_no[6..9])
      end

    return bus_addr
  end
  def display_map_info(business)
    address = display_address(business)
    html = <<EOF
    <div id="map-locations#{business.id}">
		  <div class="location#{business.id}" data-jmapping="{id: 1, point: {lng: #{business.longitude}, lat: #{business.latitude}}, category: 'restaurant'}">
		    <a href="#" class="map-item#{business.id}">#{business.name}</a>
		    <div class="info-html#{business.id}">
		      <p>#{business.name}<br>#{address}</p>
		    </div>
		  </div>
		</div>
EOF
    
    return html
  end
  def display_main_map_info(businesses)
    business1 = businesses[0]
    address1  = display_address(business1) 
    business2 = businesses[1]
    address2  = display_address(business2)
    business3 = businesses[2]
    address3  = display_address(business3)
    
    html = <<EOF  
  	<div id="map-side-bar"> 
			<div class="map-location" data-id="1" data-point="{lng: #{business1.longitude}, lat: #{business1.latitude}}" data-category="'restaurant'"> 
				<a href="#" class="map-link">#{business1.name}</a> 
				<div class="info-box"> 
					<p>#{business1.name}<br>#{address1}</p> 
				</div> 
			</div> 
			<div class="map-location" data-id="2" data-point="{lng: #{business2.longitude}, lat: #{business2.latitude}}" data-category="'restaurant'"> 
				<a href="#" class="map-link">#{business2.name}</a> 
				<div class="info-box"> 
					<p>#{business2.name}<br>#{address2}</p> 
				</div> 
			</div> 
			<div class="map-location" data-id="3" data-point="{lng: #{business3.longitude}, #{business3.latitude}}" data-category="'restaurant'"> 
				<a href="#" class="map-link">#{business3.name}</a> 
				<div class="info-box"> 
					<p>#{business3.name}<br>#{address3}</p> 
				</div> 
			</div> 
		</div>
EOF
    return html		  
  end
end
