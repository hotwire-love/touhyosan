Rails.application.routes.draw do
  root 'polls#new'

  resources :polls, only: [:show, :new, :create] do
    resources :choices, only: [:index, :create, :destroy], module: :polls
    resources :votes, only: [:new, :create, :edit, :update], module: :polls
  end
end
