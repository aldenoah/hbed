Rails.application.routes.draw do
  resources :uploads
  resources :locations
  resources :bookings
  
  get 'listings' => "rooms#listings"
  get 'inactive-listings' => "rooms#inactive_listings"
  
  get 'reservations' => 'bookings#reservations'
  get 'checked-in' => 'bookings#checked_in'
  get 'checked-out' => 'bookings#checked_out'
  get 'guest-cancelled' => 'bookings#guest_cancelled'
  get 'no-shows' => 'bookings#no_shows'

  get 'pending-transfers' => 'bookings#transfer_pending'
  get 'confirmed-transfers' => 'bookings#transfer_confirm'

  get 'upcoming' => "bookings#upcoming"
  get 'departed' => "bookings#departed"
  get 'cancelled' => "bookings#cancelled"
  
  match 'update_listing_status' => "rooms#update_listing_status", via: :post

  match 'update_status' => "bookings#update_status", via: :post
  match 'cancel_booking' => "bookings#cancel_booking", via: :post
  match 'checking_out' => "bookings#checking_out", via: :post
  match 'verify_transfer' => "bookings#verify_transfer", via: :post

  get 'rooms/update_timeslots', :as => 'update_timeslots'
  get 'rooms/block_timeslots', :as => 'block_timeslots'
  get 'rooms/block_timeslots_next', :as => 'block_timeslots_next'


  get 'payment-instruction' => "bookings#payment_instruction"
 
  resources :rooms do
    resources :room_steps, path: "steps", only: [:show, :update]
  	collection do
  		match 'search' => 'rooms#search', via: [:get, :post], as: :search
      match 'search-refined' => 'rooms#search_refined', via: [:get, :post], as: :search_refined
  		match 'book' => 'rooms#book', via: [:get, :post], as: :book
  	end
  end

  get 'rooms/:id/calendar' => "rooms#calendar", as: :calendar
  
  resources :areas
  
  devise_for :users
  resources :users, only: [:index, :show, :edit, :update]

  root 'welcome#index'

end
