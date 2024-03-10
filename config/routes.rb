Rails.application.routes.draw do
  root "polls#new"

  resources :pre_polls, only: [:show, :edit, :update] do
    member do
      get 'accept'
      get 'redirectx'
    end

    resources :proposals, only: [:new, :create, :edit, :update], module: :pre_polls
  end

  resources :polls, only: [:show, :new, :create] do
    resources :votes, only: [:new, :create, :edit, :update], module: :polls
  end
end
