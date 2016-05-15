class RoomStepsController < ApplicationController
  include Wicked::Wizard
  steps :about, :pricing, :photos

  def show
    @room = Room.find(params[:room_id])
    6.times do
      @room.uploads.build
    end
    render_wizard
  end

  def update
    @room = Room.find(params[:room_id])
    @room.update(room_params)
    render_wizard @room
  end

private
  def finish_wizard_path
    inactive_listings_path
  end

  def room_params
    params.fetch(:room, {}).permit(:cover, :name, :title, :description, :booking_start, :booking_end, :active, 
                                  :location, :latitude, :longitude, :district, :area_id, :direction, :user_id, 
                                  :deposit, :room_type, :price_per_three_hour, :price_per_three_hour_currency, 
                                  :price_per_extra_hour, :price_per_extra_hour_currency, :price_per_extra_guest,
                                  :price_per_extra_guest_currency, :deposit, :deposit_currency,
                                  :free_wifi, :free_parking, :outdoor_pool, uploads_attributes: [:id, :image, :room_id, :_destroy])
  end
end
