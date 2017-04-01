Rails.application.routes.draw do

  root 'index#index'
  resources :registration
  resources :login

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
