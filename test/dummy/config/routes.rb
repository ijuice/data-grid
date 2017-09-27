Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :dummy, only: [:index]
  resources :two_tables, only: [:index]
end
