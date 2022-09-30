Rails.application.routes.draw do
  root 'polls#new'

  resources :polls, only: [:show, :new, :create]
end
