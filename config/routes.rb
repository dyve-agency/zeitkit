Timetracker::Application.routes.draw do

  root :to => "static#home"

  resources :users, only: [:new, :create, :show], shallow: true do
    resources :clients
    resources :worklogs
  end

  resources :sessions
  get "logout" => "sessions#destroy", :as => "logout"
  get "login" => "sessions#new", :as => "login"
  get "signup" => "users#new", :as => "signup"
end
