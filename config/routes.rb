Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :readings, only: [:create, :show]
  resources :stats, only: :index
end
