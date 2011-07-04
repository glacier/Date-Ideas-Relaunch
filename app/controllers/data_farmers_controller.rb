class DataFarmersController < ApplicationController
  # before_filter :authenticate_admin!
  # skip_load_resource
  # load_and_authorize_resource

  def update_neighbourhood_select
    logger.info("update neighbourhood select ")
    @data_farmer = DataFarmer.new
    neighbourhoods = Neighbourhood.where(:city=>params[:city]).order(:neighbourhood) unless params[:city].blank?
    logger.info("neighbourhood size:" + neighbourhoods.length.to_s)
    render :partial => "neighbourhoods", :locals => {:neighbourhoods => neighbourhoods}
  end

  def index
    @data_farmer = DataFarmer.new
    @categories = Category.find_all_by_parent_name('')
    @neighbourhoods = Neighbourhood.find_by_city('Toronto')
    respond_to do |format|
      format.html
    end

    authorize! :manage, :data_farmers
  end

  def farm
    @data_farmer = DataFarmer.new
    interval = 20
    neighbourhoods = []
    neighbourhood = params[:neighbourhood]
    city = params[:data_farmer][:city]
    logger.info("city:" + city.to_s)

    neighbourhoods.push(neighbourhood)
    categories = params[:categories]

    db_neighbourhoods_hash = {}
    db_neighbourhoods = Neighbourhood.all
    db_neighbourhoods.each do |db_n|
      db_neighbourhoods_hash[db_n.neighbourhood] = db_n
    end

    db_categories_hash = {}
    db_categories = Category.all

    db_categories.each do |c|
      db_categories_hash[c.name] = c
    end

    if (!neighbourhood.nil? && !categories.nil?)
      farmed_info = FarmedInfo.find_by_neighbourhood_and_categories(neighbourhood, categories.join(','))
    elsif (!neighbourhood.nil?)
      farmed_info = FarmedInfo.find_by_neighbourhood(neighbourhood)
    end

    offset = 0

    if (farmed_info.nil?)
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
    yelp_adaptor = DateIdeas::YelpAdaptorV2.new(logger, false)
    yelp_businesses = yelp_adaptor.search(city, categories, neighbourhoods, offset)
    yelp_businesses.each do |biz|
      save = true
      biz_h = []
      biz.neighbourhoods.each do |biz_hoods|
        if (db_neighbourhoods_hash.has_key?(biz_hoods.neighbourhood))
          biz_h.push(db_neighbourhoods_hash.fetch(biz_hoods.neighbourhood))
        else
          save = false
          break
        end
      end
      biz.neighbourhoods = biz_h

      biz_c = []
      biz.categories.each do |cat|
        if (db_categories_hash.has_key?(cat.name))
          biz_c.push(db_categories_hash.fetch(cat.name))
        else
          save = false
          break
        end
      end
      biz.categories = biz_c
        #check if it's already in the database
      tmp_biz = Business.find_by_external_id(biz.external_id)

      if (tmp_biz.nil?)
        tmp_biz = Business.find(:first, :conditions => ['businesses.name = ? AND businesses.address1 = ?', biz.name, biz.address1])
        if (!tmp_biz.nil?)
          tmp_biz.photo_url = biz.photo_url
          tmp_biz.longitude = biz.longitude
          tmp_biz.latitude = biz.latitude
          tmp_biz.external_id = biz.external_id
          tmp_biz.save
        end
      end

      if (!tmp_biz.nil?)

        save=false

      end

      if (save)
        saved_counter = saved_counter + 1
        biz.dna_pricepoint = scrapy.get_price_range(biz.external_id)
        biz.save
      end
    end
    if (saved_counter > 0)
      farmed_info.loaded = farmed_info.loaded + saved_counter
      farmed_info.save
    end

    @farmed_info = FarmedInfo.all

    respond_to do |format|
      format.html
    end

    authorize! :manage, :data_farmers
  end
end
