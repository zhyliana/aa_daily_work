Cats99::Application.routes.draw do
  resources :cats
  resources :cat_rental_requests
  resources :users
  resource :session
end
