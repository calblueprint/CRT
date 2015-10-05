Rails.application.routes.draw do

  resources :projects

  root 'projects#index'
  #root 'static_pages#home'
  
  get '/home', to: 'static_pages#home'
  get '/help', to: 'static_pages#help'
end
