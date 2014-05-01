Rails.application.routes.draw do

  root 'schedules#show_cart'

  resources :schedules

  match '/reset', to: "schedules#reset", via: [:get, :post]
  match '/show_cart', to: "schedules#show_cart", via: [:get, :post]
  match '/preview', to: "schedules#confirmation_screen", via: [:get, :post]
  match '/add_course', to: "schedules#add_course", via: [:post]
  match '/confirmation', to: "schedules#generate_schedule", via: [:get, :post]

end
