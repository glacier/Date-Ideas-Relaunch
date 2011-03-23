class DateIdeas::DnaService
  def search(venue_type,location,price_point = 'price_point',page = 'page')
    puts("DateIdeas.search:" << venue_type.to_s << ":" << location.to_s << ":" << price_point.to_s << ":" << page.to_s)

    #neighbourhoods = Neighbourhood.where(:district_subsection => location )
    #neighbourhood_list = String.new
    #delim = String.new
    #neighbourhoods.each do |n|
    #  neighbourhood_list.concat(delim).concat("'").concat(n.neighbourhood).concat("'")
    #  delim = String.new(',')
    #end
    #grab from DI db.
    categories = Array.new
    neighbourhoods = Array.new
    businesses = Business.find(:all,:joins => :neighbourhoods, :conditions => ['neighbourhoods.district_subsection=?',location ] ).paginate(:page => page, :per_page => 4)
    businesses.each do |b|
      puts("=========================")
      puts("business name:" << b.name)
      if (! b.categories.nil? ) 
        puts("category:" << b.categories[0].name.to_s )
        categories.push( b.categories[0].name )
      else
        puts("category: is null")
      end
      if (! b.neighbourhoods.nil? && !b.neighbourhoods.empty? && !b.neighbourhoods[0].nil? ) 
        puts("neighbourhood:" << b.neighbourhoods[0].neighbourhood.to_s )
        neighbourhoods.push( b.neighbourhoods[0].neighbourhood )
      else
        puts("neighbourhood: is null")
      end
    end
    
    #grab from Yelp
    yelp_businesses = DateIdeas::YelpAdaptor.new.search(venue_type,'test',price_point,page);
    #businesses.concat(yelp_businesses)
    puts("return:" << yelp_businesses.to_s )
    #puts("return:"<< businesses.to_s)
    return businesses
  end
end
