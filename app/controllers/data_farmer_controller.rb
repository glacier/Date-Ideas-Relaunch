class DataFarmerController < ApplicationController
  # before_filter :authenticate_admin!
  # skip_load_resource
  # load_and_authorize_resource
  def index
    @neighbourhoods = Neighbourhood.find_all_by_district("Old City of Toronto")
#    logger.info("neighbourhoods:" + @neighbourhoods.to_s)
    @categories = Category.find_all_by_parent_name('')
    @neighbourhoods_select = Array.new
    @neighbourhoods.each do |n|
      neighbourhood_element = Array.new
      neighbourhood_element.push(n.neighbourhood)
      neighbourhood_element.push(n.neighbourhood)
      @neighbourhoods_select.push(neighbourhood_element)
    end
    respond_to do |format|
      format.html # index.html.erb
    end
    
    authorize! :manage, :data_farmer
  end
  def farm
    interval = 20
    neighbourhoods = Array.new
    neighbourhood = params[:neighbourhood]
    neighbourhoods.push(neighbourhood)
    categories =  params[:categories]

    logger.info("neighbourhood selected:" + neighbourhood)
    logger.info("categories :" + categories.to_s )

    db_neighbourhoods_hash = Hash.new
    db_neighbourhoods = Neighbourhood.all
    db_neighbourhoods.each do |db_n |
       db_neighbourhoods_hash[db_n.neighbourhood] = db_n
    end

    db_categories_hash = Hash.new
    db_categories = Category.all

    db_categories.each do |c|
      db_categories_hash[c.name] = c
    end


    farmed_info = FarmedInfo.find_by_neighbourhood_and_categories(neighbourhood, categories.join(','))
    offset = 0
    if(farmed_info.nil? )
      farmed_info = FarmedInfo.new
      farmed_info.neighbourhood = neighbourhood
      farmed_info.offset=offset
      farmed_info.loaded = 0
      farmed_info.categories = categories.join(',')
    else
      offset = farmed_info.offset + interval
      farmed_info.offset=offset
      farmed_info.categories = categories.join(',')
    end

    saved_counter = 0
    scrapy = DateIdeas::ScreenScraper.new(logger)
    yelp_adaptor = DateIdeas::YelpAdaptorV2.new('Z720kWRw-CAauOQNUbMEAQ','e7999uMADazHkmG5NDVDWBykczc','1Gj9nSZwzv_o5F_egAYGgYDBsdTdeKFZ','Yd98KQPlSAOWXfmHYsTctbihEH4', logger ,false)
    yelp_businesses = yelp_adaptor.search('Toronto',categories, neighbourhoods, offset)
    yelp_businesses.each do |biz|
      save = true
      biz_h = Array.new
      biz.neighbourhoods.each do | biz_hoods |
        if( db_neighbourhoods_hash.has_key?(biz_hoods.neighbourhood))
          biz_h.push(db_neighbourhoods_hash.fetch(biz_hoods.neighbourhood))
        else
          save = false
          break
        end
      end
      biz.neighbourhoods = biz_h

      biz_c = Array.new
      biz.categories.each do | cat |
        if(db_categories_hash.has_key?(cat.name ))
          biz_c.push(db_categories_hash.fetch(cat.name))
        else
          save = false
          break
        end
      end
      biz.categories = biz_c
      #check if it's already in the database
      tmp_biz = Business.find_by_external_id(biz.external_id)

      if(tmp_biz.nil?)
        tmp_biz = Business.find(:all, :conditions => ['businesses.name = ? AND businesses.address1 = ?',biz.name,biz.address1])
        tmp_biz.photo_url = biz.photo_url
        tmp_biz.longitude = biz.longitude
        tmp_biz.latitude  = biz.latitude
        tmp_biz.external_id = biz.external_id
        tmp_biz.save
      end

      if(!tmp_biz.nil?)
        save=false
      end

      if( save )
        saved_counter = saved_counter + 1
        biz.dna_pricepoint = scrapy.get_price_range(biz.external_id)
        biz.save
      end
    end
    farmed_info.loaded = farmed_info.loaded + saved_counter
    farmed_info.save

    @farmed_info = FarmedInfo.all

    respond_to do |format|
      format.html
    end
    
    authorize! :manage, :data_farmer
  end
end
