Rails.application.routes.draw do
  root 'polls#new'

  resources :polls, only: [:show, :new, :create] do
    resources :votes, only: [:new, :create, :edit, :update], module: :polls
  end

  get '/mermaid', to: 'mermaid#show'
end
