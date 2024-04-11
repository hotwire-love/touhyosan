Rails.application.routes.draw do
  root "polls#new"

  resources :pre_polls, only: [:show, :update] do
    member do
      post "append"
    end
  end

  resources :polls, only: [:show, :new, :create] do
    resources :votes, only: [:new, :create, :edit, :update], module: :polls
  end
end
