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
    bus_addr = ''

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

    return bus_addr
  end
  def display_phone_no(business)
    bus_phone = ''
    
    if ! (business.phone_no.nil? || business.phone_no.empty?)
      phone_number = business.phone_no.gsub(/\./,'')
      bus_phone.concat(" (").concat(phone_number[0..2]).concat(") ").concat(phone_number[3..5]).concat("-").concat(phone_number[6..9])
    end
    
    return bus_phone
  end
end
