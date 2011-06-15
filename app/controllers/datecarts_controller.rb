class DatecartsController < ApplicationController
  # GET /datecarts
  # GET /datecarts.xml
  load_and_authorize_resource
  include DatecartsHelper

  before_filter :authenticate_user!, :except => :subscribe
  
  def index
    @datecarts = Datecart.all

    respond_to do |format|
      format.js
      format.html # index.html.erb
      format.xml  { render :xml => @datecarts }
    end
  end

  # GET /datecarts/1
  # GET /datecarts/1.xml
  def show
    @datecart = Datecart.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @datecart }
    end
  end

  # GET /datecarts/new
  # GET /datecarts/new.xml
  def new
    @datecart = Datecart.new
      
    session[:datecart_id] = @datecart.id
    respond_to do |format|
      format.js
      format.html # new.html.erb
      format.xml  { render :xml => @datecart }
    end
  end

  # GET /datecarts/1/edit
  def edit
    @datecart = Datecart.find(params[:id])
  end

  # POST /datecarts
  # POST /datecarts.xml
  def create
    @datecart = Datecart.new(params[:datecart])

    respond_to do |format|
      if @datecart.save
        format.html { redirect_to(@datecart, :notice => 'Datecart was successfully created.') }
        format.xml  { render :xml => @datecart, :status => :created, :location => @datecart }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @datecart.errors, :status => :unprocessable_entity }
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
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @datecart.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /datecarts/1
  # DELETE /datecarts/1.xml
  def destroy
    @datecart = Datecart.find(params[:id])
    @datecart.destroy

    respond_to do |format|
      format.js
      format.html { redirect_to(current_user.profile) }
      format.xml  { head :ok }
    end
  end
  
  # datecart/:datecart_id/clear_cart
  # POST
  def clear_cart
      @datecart = Datecart.find(params[:id])
      @cleared_items = @datecart.cart_items.destroy_all
      
      respond_to do |format|
        format.js
        format.html {redirect_to(@datecart)}
      end
  end

  def begin_complete
    @datecart = Datecart.find(params[:id])
    render :save_datecart
  end
  # complete date planning
  def complete
    if current_user
      @datecart = Datecart.find(params[:id])
      @datecart.update_attributes(:user_id => current_user.id)
      if current_user.profile.nil?
        redirect_to(@datecart, :notice => 'Datecart was successfully updated.')
      else
        redirect_to(current_user.profile)
      end
    else
      # Devise not set to create users RESTFULLY 
      redirect_to(new_user_session_path)
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
  
  # render print view
  def print
    @datecart = Datecart.find(params[:id])
  end

  def calendar
    @datecart = Datecart.find(params[:id])
  end

  def download_calendar
    @datecart = Datecart.find(params[:id])
    send_data generate_vcalendar(@datecart, :download), :filename => "my_date.ics", :type => "text/calendar"
  end

  def subscribe
    @datecart = Datecart.find(params[:id])
    render :text => generate_vcalendar(@datecart, :subscribe)
  end

  private

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
DTEND:#{format_time datecart.datetime+1.hour}Z
SUMMARY: #{datecart.name}
PRIORITY:0
CATEGORIES:DATE
CLASS:PRIVATE
URL:#{request.env["REQUEST_URI"]}
DESCRIPTION: #{datecart.notes}
LOCATION: SOMEHWEREEERERERE
END:VEVENT
END:VCALENDAR
VCAL
  end
end
