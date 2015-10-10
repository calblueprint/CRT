Rails.application.routes.draw do

  resources :projects

  root 'projects#index'
  #root 'static_pages#home'
  
  get '/home', to: 'static_pages#home'
  get '/help', to: 'static_pages#help'
  get '/index', to: 'static_pages#index'
  get '/project', to: 'static_pages#project'
  get '/information', to: 'static_pages#information'
end
