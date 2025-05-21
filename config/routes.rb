Rails.application.routes.draw do
  root 'polls#new'

  resources :polls, only: [:show, :new, :create] do
    resources :choices, only: [:index, :create, :destroy, :edit, :update], module: :polls
    resources :votes, only: [:new, :create, :edit, :update], module: :polls
  end
  # config/routes.rb
  post 'markdown_preview', to: 'markdown_preview#create'
end
