Rails.application.routes.draw do
  resources :rooms
  resources :areas
  devise_for :users
  
  root 'welcome#index'

end
