Rails.application.routes.draw do

  get 'data_types/index'

  resources :projects
  resources :data_types

  root 'projects#index'
  #root 'static_pages#home'
  
  get '/home', to: 'static_pages#home'
  get '/help', to: 'static_pages#help'
end
