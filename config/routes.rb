Timetracker::Application.routes.draw do

  root :to => "static#home"

  resources :users, only: [:new, :create, :show, :edit, :update], shallow: true do
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
    resources :worklogs, except: [:show]
    resources :invoices do
      member do
        post "toggle_paid"
        get "pdf_export"
      end
    end
    resources :invoice_default, only: [:update, :edit]
    resources :expenses, except: [:show]
    resources :products, except: [:show]
  end

  resources :sessions
  resources :password_resets, only: [:create, :edit, :update, :new]

  get "logout" => "sessions#destroy", :as => "logout"
  get "login" => "sessions#new", :as => "login"
  get "signup" => "users#new", :as => "signup"
  get "home" => "users#dynamic_home", :as => "dynamic_home"
  get "users/:id/worklogs/pdf_export" => "worklogs#pdf_export", :as => "pdf_export"
  post "signup_email" => "users#signup_email", :as => "signup_email"
end
