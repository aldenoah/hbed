class BookingsController < ApplicationController
  before_action :set_booking, only: [:show, :edit, :update, :destroy, :verify_transfer, :cancel_booking, :update_status, :checking_out]
  before_filter :admin_signed_in?, only: [:index, :transfer_pending, :transfer_confirm, :verify_transfer, :edit, :update, :destroy]

  # GET /bookings
  # GET /bookings.json
  def payment_instruction
  end

  def transfer_pending
    @bookings = Booking.where(paid: false, payment_method: "Bank Transfer").includes(:buyer)
  end

  def transfer_confirm
    @bookings = Booking.where(paid: true, payment_method: "Bank Transfer").includes(:buyer)
  end

  def verify_transfer
    if params[:commit] == "Confirm"
      @booking.update_attributes(paid: true)
      #send_message(@booking.phone, "Thanks for the payment! Your HourBeds booking #{@booking.id} is confirmed. Visit HourBeds.com for more info")
      #send message to seller
    elsif params[:commit] == "Delete"
      @booking.destroy
    end
    redirect_to pending_transfers_url
  end

  def reservations
    @bookings = Booking.where(seller_id: current_user.id, status: "Upcoming").that_are_paid
  end

  def checked_in
    @bookings = Booking.where(seller_id: current_user.id, status: "Checked In")
  end

  def checked_out
    @bookings = Booking.where(seller_id: current_user.id, status: "Checked Out")
  end

  def no_shows
    @bookings = Booking.where(seller_id: current_user.id, status: "No Show")
  end

  def guest_cancelled
    @bookings = Booking.where(seller_id: current_user.id, status: "Cancelled")
  end

  def upcoming
    @bookings = Booking.where("buyer_id = ? AND start_date >= ? AND status != ? AND status != ?  AND payment_method != ?", current_user.id, Date.today, "Cancelled", "No Show", "Block")
  end

  def departed
    @bookings = Booking.where("buyer_id = ? AND start_date < ? AND status != ? AND status != ? AND payment_method != ?", current_user.id, Date.today, "Cancelled", "No Show", "Block")
  end

  def cancelled
    @bookings = Booking.where(buyer_id: current_user.id, status: "Cancelled")
  end

  def cancel_booking
    @booking.update_attribute(:status, "Cancelled")
    redirect_to upcoming_url
  end

  def update_status
    if params[:commit] == "Check In"
      @booking.update_attribute(:status, "Checked In")
    elsif params[:commit] == "No Show"
      @booking.update_attribute(:status, "No Show")
    end
    redirect_to reservations_url
  end

  def checking_out
    @booking.update_attribute(:status, "Checked Out")
    redirect_to reservations_url
  end

  def index
    @bookings = Booking.all.order('id ASC').that_are_paid
  end

  # GET /bookings/1
  # GET /bookings/1.json
  def show
  end

  # GET /bookings/new
  def new
    @booking = Booking.new
  end

  # GET /bookings/1/edit
  def edit
  end

  # POST /bookings
  # POST /bookings.json
  def create
    @booking = Booking.new(booking_params)
    room = Room.find(@booking.room_id)    
    
    @booking.buyer_id = current_user.id if user_signed_in?
    @booking.seller_id = room.user_id
    @booking.room_name = room.name
    @booking.room_title = room.title
    @booking.booking_code = Booking.generate_booking_code
    if params[:payment_method].present?
      @booking.payment_method = params[:payment_method]
    else
      @booking.payment_method = "Block"
    end

    respond_to do |format|
      if @booking.save
        if @booking.payment_method == "Bank Transfer"
          format.html { redirect_to payment_instruction_url(transfer: @booking.service_fee) }
          #send_message("+60138810882", "[HB][##{@booking.id}] Brace yourself for RM#{@booking.service_fee} bank transfer from #{@booking.first_name}(#{@booking.phone}). Visit HourBeds.com for more info")
        elsif @booking.payment_method == "Block"
          format.html { redirect_to calendar_url(room, start_date: @booking.start_date) }
        else
          format.html { redirect_to booking_url(@booking), notice: 'Booking was successfully created.' }
          #send_message("+15005550001", "You got a #{@booking.duration} hour reservation for #{@booking.room_name.truncate(20)} (#{@booking.check_in.strftime("%b %d, %Y - %l:%M %p")}). Visit HourBeds.com for more info")
        end
        format.json { render :show, status: :created, location: @booking }
      else
        format.html { render :new }
        format.json { render json: @booking.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /bookings/1
  # PATCH/PUT /bookings/1.json
  def update
    respond_to do |format|
      if @booking.update(booking_params)
        format.html { redirect_to bookings_url, notice: 'Booking was successfully updated.' }
        format.json { render :show, status: :ok, location: @booking }
      else
        format.html { render :edit }
        format.json { render json: @booking.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /bookings/1
  # DELETE /bookings/1.json
  def destroy
    @booking.destroy
    respond_to do |format|
      if @booking.payment_method == 'Block'
        format.html { redirect_to calendar_url(@booking.room_id) }
        format.json { head :no_content }
      else
        format.html { redirect_to bookings_url, notice: 'Booking was successfully destroyed.' }
        format.json { head :no_content }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_booking
      @booking = Booking.find(params[:id])
    end

    def send_message(number, message)
      twilio_number = ENV["twilio_number"]
      client = Twilio::REST::Client.new(ENV["twilio_account_sid"], ENV["twilio_auth_token"])
      phone_number = number #"+15005550001"

      message = client.account.messages.create(
        :from => twilio_number,
        :to => phone_number,
        :body => message,
      )
      puts message.to
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def booking_params
      params.require(:booking).permit(:seller_id, :buyer_id, :room_id, :first_name, :last_name,
                                      :email, :phone, :duration, :guest, :subtotal, 
                                      :service_fee, :total, :room_name, :room_title, :status, :paid,
                                      :check_in, :check_out, :start_date, :booking_code, :payment_method)
    end
end
