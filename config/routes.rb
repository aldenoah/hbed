Rails.application.routes.draw do
  resources :rooms do
  	collection do
  		match 'search' => 'rooms#search', via: [:get, :post], as: :search
  		match 'book' => 'rooms#book', via: [:get, :post], as: :book
  	end
  end
  
  resources :areas
  devise_for :users
  
  root 'welcome#index'

end
