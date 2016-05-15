class RoomsController < ApplicationController
  before_action :set_room, only: [:show, :edit, :update, :destroy, :book, :calendar, :update_timeslots, :update_listing_status, :block_timeslots, :block_timeslots_next]
  before_action :check_arrival, :authenticate_user!,  only: [:book]
  before_filter :admin_signed_in?, only: [:index]

  # GET /rooms
  # GET /rooms.json
  def book
    @booking = Booking.new
    @duration = params[:hour].to_i
    @guest = params[:guest].to_i
    @start_date = params[:date]
    @check_in = params[:check_in].to_datetime
    @check_out = @check_in + @duration.hour    
    
    @total = params[:grand_total].to_money
    
    @pay_later =  @total/1.2
    @pay_now = @total - @pay_later
    #@client_token = Braintree::ClientToken.generate #Braintree
    @grand_total = @total + @room.deposit
  end

  def search
    @area = Area.find_by_id(params[:area])

    if @area.present?
      @areas = Area.all.includes(:location)
      ## Search with timeslots ## @bookings = Booking.where(start_date: params[:start_date]).that_are_paid

      search = Room.that_are_active.where(nil).includes(:area) # creates an anonymous scope
      search = search.located_at(params[:area]) if params[:area].present?
      search = search.districted_at(params[:district]) if params[:district].present?
      
      search = search.ransack(params[:q])
      @rooms = search.result(distinct: true).order('price_per_three_hour_sens ASC')
    else
      redirect_to root_url
    end
  end

  def search_refined
    @area = Area.find_by_id(params[:area])
    
    if @area.present?

      @areas = Area.all.includes(:location)
      ## Search with timeslots ## @bookings = Booking.where(start_date: params[:start_date]).that_are_paid

      search = Room.that_are_active.where(nil).includes(:area) # creates an anonymous scope
      search = search.located_at(params[:area]) if params[:area].present?
      search = search.districted_at(params[:district]) if params[:district].present?
      search = search.with_restaurant if params[:restaurant].present?
      #search = search.with_bar if params[:bar].present?
      #search = search.with_balcony if params[:balcony].present?
      search = search.with_free_wifi if params[:free_wifi].present?
      search = search.with_free_parking if params[:free_parking].present?
      search = search.with_free_airport_shuttle if params[:free_airport_shuttle].present?
      #search = search.with_meeting_rooms if params[:meeting_rooms].present?
      search = search.with_outdoor_pool if params[:outdoor_pool].present?
      #search = search.with_indoor_pool if params[:indoor_pool].present?
      search = search.with_spa if params[:spa].present?
      #search = search.with_beauty_center if params[:beauty_center].present?
      search = search.with_fitness_room if params[:fitness_room].present?
      #search = search.with_massage if params[:massage].present?
      #search = search.with_sauna if params[:sauna].present?
      search = search.with_jacuzzi if params[:jacuzzi].present?
      #search = search.with_kitchen if params[:kitchen].present?
      search = search.ransack(params[:q])
      @rooms = search.result(distinct: true).order('price_per_three_hour_sens ASC')
    else
      redirect_to root_url
    end
  end

  #def update_timeslots_alt
  #  bookings = Booking.where(room_id: params[:id]) #Booking.where(room_id: params[:id], start_date: params[:start_date])
  #  @timeslots = Room.timeslots_for(params[:start_date], params[:duration]) #Room.timeslots_for(params[:start_date])
  #  @timeslot_select = Room.timeslot_select(params[:start_date], params[:duration]) #Room.timeslot_select(params[:start_date])

  #  @result = []

  #  @timeslots.each do |ts|
  #    bookings.each do |booking|
  #      if ts.between?(booking.check_in - params[:duration].to_i.hour, booking.check_out)
  #        @result << ts
  #      end
  #    end
  #  end
  #  @result
  #end

  def update_timeslots
    room_bookings = Booking.where(room_id: params[:id]) #Booking.where(room_id: params[:id], start_date: params[:start_date])
    next_day = (params[:start_date].to_datetime + 1.day).to_date
    bookings = room_bookings.where('start_date = ? OR start_date =?', params[:start_date], next_day)
    
    @timeslots = Room.timeslots_for(params[:start_date]) #Room.timeslots_for(params[:start_date])
    @timeslot_select = Room.timeslot_select(params[:start_date]) #Room.timeslot_select(params[:start_date])

    @result = []

    @timeslots.each do |ts|
      if (ts + params[:duration].to_i.hour) < params[:start_date].to_datetime.end_of_day
        bookings.each do |booking|
          if ts.between?(booking.check_in - params[:duration].to_i.hour, booking.check_out) || ts.between?(booking.check_in, booking.check_out)
            @result << ts
          end
        end
      else
        bookings.each do |booking|
          if (ts + params[:duration].to_i.hour).between?(booking.check_in - params[:duration].to_i.hour, booking.check_out) || ts.between?(booking.check_in, booking.check_out)
            @result << ts
          end
        end
      end
    end
    @result
  end

  def block_timeslots
    room_bookings = Booking.where(room_id: params[:id]) #Booking.where(room_id: params[:id], start_date: params[:start_date])
    next_day = (params[:start_date].to_datetime + 1.day).to_date
    bookings = room_bookings.where('start_date = ? OR start_date =?', params[:start_date], next_day)

    @timeslots = Room.timeslots_for(params[:start_date])
    @timeslot_select = Room.timeslot_select(params[:start_date])

    @result = []

    @timeslots.each do |ts|
      bookings.each do |booking|
        if ts.between?(booking.check_in, booking.check_out - 1.second)
          @result << ts
        end
      end
    end
    @result
  end

  def block_timeslots_next
    room_bookings = Booking.where(room_id: params[:id]) #Booking.where(room_id: params[:id], start_date: params[:start_date])
    next_day = (params[:start_date].to_datetime + 1.day).to_date
    bookings = room_bookings.where('start_date = ? OR start_date =?', params[:start_date], next_day)

    @timeslots = Room.timeslots_for(params[:start_date])
    @timeslot_select = Room.timeslot_select(params[:start_date])

    @result_next = []

    @timeslots.each do |ts|
      bookings.each do |booking|
        if ts.between?(booking.check_in, booking.check_out - 1.second)
          @result_next << ts
        end
      end
      if ts <= params[:check_in]
          @result_next << ts
      end
    end
    @result_next
  end



  ### Members Area ###

  def listings
    @rooms = Room.where(active: true)
  end

  def inactive_listings
    @rooms = Room.where(active: false)
  end

  def update_listing_status
    if params[:commit] == "Deactivate"
      @room.update_attribute(:active, false)
      redirect_to listings_url
    elsif params[:commit] == "Activate"
      @room.update_attribute(:active, true)
      redirect_to inactive_listings_url
    end
  end

  ####################
  
  def index
    @rooms = Room.all
  end

  # GET /rooms/1
  # GET /rooms/1.json
  def show
    if params[:start_date].to_date < Date.today || params[:duration].to_i < 3 || params[:duration].to_i > 9
      redirect_to root_url, notice: "Oops! Something went wrong!"
    else
      @uploads = Upload.where(room_id: @room.id)
      gon.latitude = @room.latitude
      gon.longitude = @room.longitude
      gon.price_per_extra_hour = @room.price_per_extra_hour_sens

      @timeslots = Room.timeslots_for(params[:start_date]) #Room.timeslots_for(params[:start_date])
      @timeslot_select = Room.timeslot_select(params[:start_date]) #Room.timeslot_select(params[:start_date])
    end
    #@result = []

    #@timeslots.each do |ts|
    #  @bookings.each do |booking|
    #    if ts.to_datetime.between?(booking.check_in - params[:duration].to_i.hour, booking.check_out)
    #      @result << ts
    #    end
    #  end
    #end
    #@result
  end

  # GET /rooms/new
  def new
    @room = Room.new

    6.times do
      @room.uploads.build
    end
  end

  # GET /rooms/1/edit
  def edit
    @timeslot_select = Room.timeslot_select(Date.today.to_s) #Room.timeslot_select(params[:start_date])
    @timeslots = Room.timeslots_for(Date.today.to_s)

    @bookings = Booking.where(room_id: @room.id)
    @blocks = Booking.where(room_id: @room.id, payment_method: "Block")

    image_number = 6 - @room.uploads.size
    image_number.times do
      @room.uploads.build
    end
    @booking = Booking.new
  end

  def calendar
    @timeslot_select = Room.timeslot_select(Date.today.to_s) #Room.timeslot_select(params[:start_date])
    @timeslots = Room.timeslots_for(Date.today.to_s)

    @bookings = Booking.where(room_id: @room.id)
    @blocks = Booking.where(room_id: @room.id, payment_method: "Block")

    @booking = Booking.new
  end

  

  # POST /rooms
  # POST /rooms.json
  def create
    @room = Room.new(room_params)
    @room.user_id = current_user.id

    respond_to do |format|
      if @room.save
        format.html { redirect_to room_room_step_path(room_id: @room.id, id: "about") }
        format.json { render :show, status: :created, location: @room }
      else
        format.html { render :new }
        format.json { render json: @room.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /rooms/1
  # PATCH/PUT /rooms/1.json
  def update
    respond_to do |format|
      if @room.update(room_params)
        format.html { redirect_to edit_room_url(@room), notice: 'Room was successfully updated.' }
        format.json { render :show, status: :ok, location: @room }
      else
        format.html { render :edit }
        format.json { render json: @room.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /rooms/1
  # DELETE /rooms/1.json
  def destroy
    @room.destroy
    respond_to do |format|
      format.html { redirect_to rooms_url, notice: 'Room was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_room
      @room = Room.find(params[:id])
    end

    def check_arrival
      if params[:check_in].blank?
        redirect_to_room
      end
    end

    def redirect_to_room(default = root_url)
      if request.env["HTTP_REFERER"].present? and request.env["HTTP_REFERER"] != request.env["REQUEST_URI"]
        redirect_to :back, notice: "Please select your arrival time!"
      else
        redirect_to default, notice: "Oops! something went wrong"
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def room_params
      params.fetch(:room, {}).permit(:cover, :name, :title, :description, :booking_start, :booking_end, :active, 
                                   :location, :latitude, :longitude, :district, :area_id, :direction, :user_id, 
                                   :deposit, :room_type, :price_per_three_hour, :price_per_three_hour_currency, 
                                   :price_per_extra_hour, :price_per_extra_hour_currency, :price_per_extra_guest,
                                   :price_per_extra_guest_currency, :deposit, :deposit_currency,
                                   :free_wifi, :free_parking, :outdoor_pool, uploads_attributes: [:id, :image, :room_id, :_destroy])
    end

end
