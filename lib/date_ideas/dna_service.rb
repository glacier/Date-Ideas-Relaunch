class DateIdeas::DnaService
  def search(venue_type,location,price_point = 'price_point',page = 'page')
    puts("DateIdeas.search:" << venue_type.to_s << ":" << location.to_s << ":" << price_point.to_s << ":" << page.to_s)

    neighbourhoods = Neighbourhood.where(:district_subsection => location )
    neighbourhood_list = String.new
    delim = String.new
    neighbourhoods.each do |n|
      neighbourhood_list.concat(delim).concat("'").concat(n.neighbourhood).concat("'")
      delim = String.new(',')
    end
    #grab from DI db.
    businesses = Business.paginate :page => page, :per_page => 4

    #grab from Yelp
    yelp_businesses = DateIdeas::YelpAdaptor.new.search(venue_type,neighbourhood_list,price_point,page);
    businesses.concat(yelp_businesses)
    #puts("return:"<< businesses.to_s)
    return businesses
  end
end
