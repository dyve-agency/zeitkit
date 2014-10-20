Timetracker::Application.routes.draw do

  get "kpis/new"

  root :to => "static#home"

  resources :users, only: [:new, :create, :show, :edit, :update] do
    collection do
      get :usernames
    end
    member do
      get :github_commit_messages
      get :clients
      get :shared_clients
    end
  end
  resources :kpis, only: [:new, :create]
  resources :clients
  resources :temp_worklog_saves, only: [:update], as: "temp_worklog_save"
  resources :notes do
    member do
      get "public"
      post "share"
      post "new_share_link"
      post "unshare"
    end
  end

  resources :worklogs
  resources :invoices do
    member do
      post "toggle_paid"
      get "pdf_export"
    end
  end
  resources :client_shares, only: [:destroy]

  resources :invoice_default, only: [:update, :edit]
  resources :expenses, except: [:show]
  resources :products, except: [:show]

  resources :sessions
  resources :password_resets, only: [:create, :edit, :update, :new]

  get "logout" => "sessions#destroy", :as => "logout"
  get "login" => "sessions#new", :as => "login"
  get "signup" => "users#new", :as => "signup"
  get "home" => "users#dynamic_home", :as => "dynamic_home"
  get "users/:id/worklogs/pdf_export" => "worklogs#pdf_export", :as => "pdf_export"
  post "signup_email" => "users#signup_email", :as => "signup_email"
  post "hide_tutorial" => "tutorial#hide", as: "hide_tutorial"
  get "show_tutorial" => "tutorial#show", as: "show_tutorial"

  get "/auth/:provider/callback" => "sessions#auth_provider_callback"

end
