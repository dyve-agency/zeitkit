Timetracker::Application.routes.draw do

  root :to => "static#home"

  resources :users, only: [:new, :create, :show], shallow: true do
    resources :clients, except: [:show]
    resources :start_time_saves, only: [:destroy], as: "start_time_save"
    resources :worklogs, except: [:show] do
      member do
        post "toggle_paid"
      end
    end
    resources :invoices
    member do
      post "update_savetime"
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
