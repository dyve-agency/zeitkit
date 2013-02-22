Timetracker::Application.routes.draw do

  root :to => "static#home"

  resources :users, only: [:new, :create, :show, :edit, :update], shallow: true do
    member do
      post "update_savetime"
    end
    resources :clients, except: [:show]
    resources :start_time_saves, only: [:destroy], as: "start_time_save"
    resources :notes do
      member do
        get "public"
        post "share"
        post "new_share_link"
        post "unshare"
      end
    end
    resources :worklogs, except: [:show] do
      member do
        post "toggle_paid"
      end
    end
    resources :invoices do
      member do
        post "toggle_paid"
      end
    end
    resources :invoice_default, only: [:update, :edit]
  end

  resources :sessions
  resources :password_resets, only: [:create, :edit, :update, :new]

  get "logout" => "sessions#destroy", :as => "logout"
  get "login" => "sessions#new", :as => "login"
  get "signup" => "users#new", :as => "signup"
  get "home" => "users#dynamic_home", :as => "dynamic_home"
  post "signup_email" => "users#signup_email", :as => "signup_email"
end
