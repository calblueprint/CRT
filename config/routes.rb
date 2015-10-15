Rails.application.routes.draw do

  resources :projects

  # root 'projects#index'
  root 'static_pages#home'
  
  get '/home', to: 'static_pages#home'
  get '/help', to: 'static_pages#help'
  get '/index', to: 'static_pages#index'
  get '/new-project', to: 'static_pages#new-project'
  get '/project', to: 'static_pages#project'
  get '/project-details', to: 'static_pages#project-details'
  get '/project-attributes', to: 'static_pages#project-attributes'
  get '/attributes', to: 'static_pages#attributes'
  get '/new-attribute', to: 'static_pages#new-attribute'
  get '/rearrange-attributes', to: 'static_pages#rearrange-attributes'
  get '/edit-attribute', to: 'static_pages#edit-attribute'
  get '/information', to: 'static_pages#information'

end
