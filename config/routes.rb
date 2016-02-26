Rails.application.routes.draw do
  root 'projects#index'

  devise_for :users, path_names: {
    sign_up: ''
  }

  resources :projects do
    resources :project_years
    collection do
      post 'import', to: 'projects#import'
    end
  end
  resources :data_types
  resources :years
  resources :data_values, only: [:update]

  namespace :api, defaults: { format: "json" } do
    namespace :v1 do
      resources :project_years, only: [:index]
    end
  end

  # Static routes for mockups
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
