Timetracker::Application.routes.draw do
  root :to => "static#home"
  #resources :users, only: [:new, :create]
  #resources :sessions
end
