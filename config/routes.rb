Rails.application.routes.draw do
  root 'polls#new'

  resources :polls, only: [:show, :new, :create] do
    resources :choices, only: [:index, :create, :destroy, :edit, :update], module: :polls
    resources :votes, only: [:new, :create, :edit, :update, :destroy], module: :polls
  end
end
