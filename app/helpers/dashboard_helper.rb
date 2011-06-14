module DashboardHelper
  def format_date_header date, significant = false, friend = false
    scope = {:scope => [:dashboard, :datecart]}
    if date
      if date > DateTime.now
        if significant
          sym = :upcoming_sig
        elsif friend
          sym = :upcoming_friend
        else
          sym = :upcoming
        end
      else
        if significant
          sym = :past_sig
        elsif friend
          sym = :past_friend
        else
          sym = :past
        end
      end
      I18n.t(sym, scope) + date.to_s
    else
      link_to I18n.t(:no_date_set, scope) #Choose where they need to go to set the date
    end
  end

  def format_google_maps_api_call_parameters cart_items
    parameters = {
        :size => ParamFile.new.google_maps_static_api_dimensions,
        :sensor => false
    }
    result = ""
    parameters.each do |key, val|
      result << "#{key}=#{val}&"
    end
    result << format_google_maps_markers(cart_items)
    p result
  end

  private

  def format_google_maps_markers cart_items
    markers = ""
    cart_items.each do |cart_item|
      next unless cart_item.business_id
      business = cart_item.business
      puts business
      Rails.logger.debug business
        markers << "markers=color:blue|label:#{business.name}|#{business.address1},#{business.city},#{business.province},#{business.postal_code},#{business.country}&"
    end
    markers
  end
end
