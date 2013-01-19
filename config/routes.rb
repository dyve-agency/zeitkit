Timetracker::Application.routes.draw do
  root :to => "static#home"
  resources :users, only: [:new, :create]
  resources :sessions
  get "logout" => "sessions#destroy", :as => "logout"
  get "login" => "sessions#new", :as => "login"
  get "signup" => "users#new", :as => "signup"
end
