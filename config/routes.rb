Rails.application.routes.draw do

  get 'chat/index'

  root 'index#index'
  resources :registration
  resources :login

  resources :chat

  get 'chat_handler' => 'chat#chat_handler'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
