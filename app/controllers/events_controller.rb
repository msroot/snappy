 class EventsController < ApplicationController
  before_action :set_event, only: [:show]

  # GET /events
  # GET /events.json
  def index
    @today = Time.now.to_date 
    @date = @today
    
    if params[:for_date]
      @date =  Chronic.parse(params[:for_date]).to_date
    end
     
     if params[:start_date] 
      @date = Chronic.parse(params[:start_date]).to_date
    end

    # @events = Event.includes(:place, :page).where("start_time <= ? AND end_time >= ? ", @date, @date)
    # @events = Event.includes(:place, :page).where("DATE(start_time) <= ? AND DATE(end_time) >= ? ", @date, @date)

    @events = Event.includes(:place, :page).where("DATE(start_time) = ?", @date.to_date)
    
    # where("DATE(end_time) >= ?", @date.to_date.end_of_day)
     
    # @events = Event.includes(:place, :page).
    #     where(start_time: @date.beginning_of_day..@date.end_of_day).
    #     where(end_time: @date.beginning_of_day..@date.end_of_day)
    
    
    # All upcoming
    # @upcoming =   Event.includes(:place, :page).
    #   where("DATE(end_time) >= ?", @date.end_of_day)
    # @calendar = Event.includes(:place, :page).where("start_time <= ? AND end_time >= ? ",@date.end_of_month.end_of_week,@date.beginning_of_month.beginning_of_week )
    
    # @calendar = Event.includes(:place, :page).
    # where("DATE(start_time) <= ?", @date.end_of_month.end_of_week).
    # where("DATE(end_time) >= ?", @date.beginning_of_month.beginning_of_week)
    
    @calendar = Event.includes(:place, :page).
    where(start_time: @date.beginning_of_month.beginning_of_day..@date.end_of_month.end_of_day)
  
    
    if params[:location]
      location = params[:location].split(",")
      # http://localhost:3000/events?location=37.9543975,23.7027993
      # http://localhost:3000/events?location=41.97577,21.408733&for_date=2016-09-02
      
      # Location.find_within([41.97577,21.408733])
      location_ids = Location.find_within(location).pluck(:id)
      
      @events = @events.select {|e| 
        e.place && e.place.location && location_ids.include?(e.place.location.id)
      }
      
      @calendar = @calendar.select {|e| 
        e.place && e.place.location && location_ids.include?(e.place.location.id)
      }
      
    end
    
    # only active
    # todo: check if nil
    # @events = @events.select {|e|
    #      e.end_time.to_date >= Time.now.to_date
    #     }
    
    @date_is_today = @date.to_date == Time.now.to_date
    response.headers['X-Collection-Count'] = @events.count
    page = params[:page].to_i || 1
    
    @events = @events.page(page).per(10)
    
    respond_to do |format|
          format.html 
          format.json { render json: @events.map(&:as_json_with_associations)}
        end
        
        
  end

  # GET /events/1
  # GET /events/1.json
  def show
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_event
      @event = Event.find(params[:id])
    end

end
