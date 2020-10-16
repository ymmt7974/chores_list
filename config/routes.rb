Rails.application.routes.draw do
  root 'static_pages#home'
  get '/help',    to: 'static_pages#help'
  get '/about',   to: 'static_pages#about'
  devise_for :users
  resources :chores do
    resources :chore_records, only: [:new, :edit]
  end
  resources :chore_records, only: [:create, :update, :destroy]
  resources :profiles do
    member do
      post :select
    end
  end
end
