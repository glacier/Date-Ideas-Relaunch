class CartItemsController < ApplicationController
  # GET /cart_items
  # GET /cart_items.xml
  def index
    @cart_items = CartItem.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @cart_items }
    end
  end

  # GET /cart_items/1
  # GET /cart_items/1.xml
  def show
    @datecart = Datecart.find(params[:datecart_id])
    @cart_item = @datecart.cart_items.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @cart_item }
    end
  end

  # GET /cart_items/new
  # GET /cart_items/new.xml
  def new
    @cart_item = CartItem.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @cart_item }
    end
  end

  # GET /cart_items/1/edit
  def edit
    # @cart_item = CartItem.find(params[:id])
    @datecart = Datecart.find(params[:datecart_id])
    @cart_item = @datecart.cart_items.find(params[:id])
  end

  # POST /cart_items
  # POST /cart_items.xml
  # accept a business id
  def create
    @datecart = Datecart.find(params[:datecart_id])
    @business = Business.find(params[:business_id])
    if @datecart
      @cart_item = @datecart.cart_items.build(:business => @business, :venue_type => session['venue_type'])
    end

    respond_to do |format|
      if @cart_item.save
        format.js
        format.html { 
          redirect_to(@cart_item, :notice => 'Cart item was successfully created.')
        }
        format.xml  { render :xml => @cart_item, :status => :created, :location => @cart_item }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @cart_item.errors, :status => :unprocessable_entity }
      end
    end
  end

  def create_event
    @datecart = Datecart.find(params[:datecart_id])
    @event = Rails.cache.fetch(params[:event_id])
    # unfreeze events from cache
    @event_copy = @event.dup
    # @event_copy.save
    if @datecart
      @cart_item = @datecart.cart_items.build(:event => @event_copy, :venue_type => session['venue_type'])
    end
      
    respond_to do |format|
      if @cart_item.save
        format.js
      end
    end
  end

  # PUT /cart_items/1
  # PUT /cart_items/1.xml
  def update
    @cart_item = CartItem.find(params[:id])

    respond_to do |format|
      if @cart_item.update_attributes(params[:cart_item])
        format.html { redirect_to(@cart_item, :notice => 'Cart item was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @cart_item.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /cart_items/1
  # DELETE /cart_items/1.xml
  def destroy
    @datecart = Datecart.find(params[:datecart_id])
    # @cart_item = CartItem.find(params[:id])
    @cart_item = @datecart.cart_items.find(params[:id])
    @cart_item.destroy

    respond_to do |format|
      format.js
      format.html { redirect_to(cart_items_url) }
      format.xml  { head :ok }
    end
  end
end
