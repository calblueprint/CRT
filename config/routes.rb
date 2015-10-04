Rails.application.routes.draw do
  root 'static_pages#home'
  
  get '/home', to: 'static_pages#home'
  get '/help', to: 'static_pages#help'
  get '/index', to: 'static_pages#index'

end
