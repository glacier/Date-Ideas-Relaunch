class DatecartsController < ApplicationController
  # GET /datecarts
  # GET /datecarts.xml
  load_and_authorize_resource :except => [:subscribe, :clear_cart, :print]

  include DatecartsHelper

  before_filter :authenticate_user!, :except => [:subscribe, :clear_cart, :print]
  
  def index
    @datecarts = Datecart.all

    respond_to do |format|
      format.js
      format.html # index.html.erb
      format.xml { render :xml => @datecarts }
    end
  end

    # GET /datecarts/1
    # GET /datecarts/1.xml
  def show
    @datecart = Datecart.find(params[:id])

    respond_to do |format|
      format.html { render :layout => 'dashboard' }
      format.xml { render :xml => @datecart }
    end
  end

    # creates a new datecart
  def new
    # TODO: Prompt user to save cart if current cart has not been saved

    # leave the old datecart id in the session
    unless session[:datecart_id].blank?
      session[:datecart_id_last] = session[:datecart_id]
    end
    @datecart = Datecart.new
    session[:datecart_id] = @datecart.id

    y 'a new cart has been loaded'

      # redirect user to wizard index to start planning date
    respond_to do |format|
      format.js
      format.html { redirect_to wizard_index_path }
      format.xml { render :xml => @datecart }
    end
  end

    # GET /datecarts/1/edit
  def edit
    @datecart = Datecart.find(params[:id])
    authorize! :edit, @datecart
  end

    # POST /datecarts
    # POST /datecarts.xml
  def create
    @datecart = Datecart.new(params[:datecart])

    respond_to do |format|
      if @datecart.save
        format.html { redirect_to(@datecart, :notice => 'Datecart was successfully created.') }
        format.xml { render :xml => @datecart, :status => :created, :location => @datecart }
      else
        format.html { render :action => "new" }
        format.xml { render :xml => @datecart.errors, :status => :unprocessable_entity }
      end
    end
  end

    # PUT /datecarts/1
    # PUT /datecarts/1.xml
  def update
    @datecart = Datecart.find(params[:id])

    respond_to do |format|
      if @datecart.update_attributes(params[:datecart])
        format.html { redirect_to(@datecart, :notice => 'Datecart was successfully updated.') }
        format.xml { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml { render :xml => @datecart.errors, :status => :unprocessable_entity }
      end
    end
  end

    # DELETE /datecarts/1
    # DELETE /datecarts/1.xml
  def destroy
    @datecart = Datecart.find(params[:id])
    @datecart.destroy

    respond_to do |format|
      if current_user.profile
        format.js
        format.html { redirect_to(current_user.profile) }
      else
        render :nothing => true
      end
      format.xml { head :ok }
    end
  end

    # datecart/:datecart_id/clear_cart
    # POST
  def clear_cart
    @datecart = Datecart.find(params[:id])
    @cleared_items = []
    unless @datecart.cart_empty?
      @cleared_items = @datecart.cart_items.destroy_all
    end

    respond_to do |format|
      format.js
      format.html { redirect_to(@datecart) }
    end
  end

    # Open the dialog to save a datecart from the search screen
  def begin_complete
    @datecart = Datecart.find(params[:id])
    render :save_datecart
  end

    # complete date planning
  def complete
    # User has to be logged in to reach here
    @datecart = Datecart.find(params[:id])
    begin
      params[:datecart][:datetime] = DateTime.parse params[:datecart][:datetime]
    rescue Exception
      params[:datecart][:datetime] = nil
    end

    @datecart.update_attributes(params[:datecart].merge({:user_id => current_user.id}))

    if @datecart.errors.blank?
      redirect_to(:dashboard, :notice => :'Datecart was successfully updated.')
    else
      redirect_to :back, :alert => :"There was an error saving your datecart."
    end
  end

  def email
    @datecart = Datecart.find(params[:id])
    if current_user
      UserMailer.date_plan_email(current_user, @datecart).deliver
      redirect_to(@datecart, :notice => 'An email of your Date Plan was sent!')
    else
      redirect_to(new_user_session_path)
    end
  end

    # Render print view
  def print
    @datecart = Datecart.find(params[:id])
    respond_to do |format|
      format.html {render :layout => 'itinerary_print'}
    end
  end

    # Render the calendar popup (should only be quered via remote javascript request)
  def calendar
    @datecart = Datecart.find(params[:id])
  end

    # Send the calendar as a file download, native file extensions should then handle everything (i.e. outlook)
  def download_calendar
    @datecart = Datecart.find(params[:id])
    send_data generate_vcalendar(@datecart, :download), :filename => "my_date.ics", :type => "text/calendar"
  end

    # Generate the vcal associated the datecart. Allows calendar programs to query for any updates regularly
  def subscribe
    @datecart = Datecart.find(params[:id])
    render :text => generate_vcalendar(@datecart, :subscribe)
  end

  private

    # Some samples from eventful for reference
    # ical: 'webcal://eventful.com/toronto/ical/events/nkotbsb-tour-new-kids-block-and-backstreet-boys-/E0-001-035309535-0'
    #outlook: 'http://eventful.com/toronto/ical/events/nkotbsb-tour-new-kids-block-and-backstreet-boys-/E0-001-035309535-0'

  def generate_vcalendar datecart, type
    <<-VCAL
BEGIN:VCALENDAR
CALSCALE:GREGORIAN
METHOD:PUBLISH
PRODID:-//gdi//GetDateIdeas//EN
VERSION:2.0
BEGIN:VEVENT
DTSTAMP:#{format_time DateTime.now}Z
DTSTART:#{format_time datecart.datetime}Z
DTEND:#{format_time datecart.datetime}Z
SUMMARY: Date Ideas: #{datecart.name}
PRIORITY:0
CATEGORIES:DATE
CLASS:PRIVATE
URL:#{request.env["REQUEST_URI"]}
DESCRIPTION: #{datecart.notes}
LOCATION: TODO: generate this based on sorted locations for datecart
END:VEVENT
END:VCALENDAR
    VCAL
  end
end
