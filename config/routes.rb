Timetracker::Application.routes.draw do

  root :to => "static#home"

  resources :users, only: [:new, :create, :show], shallow: true do
    resources :clients
    resources :worklogs do
      member do
        post "toggle_paid"
      end
    end
  end

  resources :sessions
  resources :password_resets, only: [:create, :edit, :update, :new]

  get "logout" => "sessions#destroy", :as => "logout"
  get "login" => "sessions#new", :as => "login"
  get "signup" => "users#new", :as => "signup"
  get "home" => "users#dynamic_home", :as => "dynamic_home"
  post "signup_email" => "users#signup_email", :as => "signup_email"
end
