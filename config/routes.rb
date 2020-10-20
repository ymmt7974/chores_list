Rails.application.routes.draw do
  root 'static_pages#home'
  get '/help',    to: 'static_pages#help'
  get '/about',   to: 'static_pages#about'
  post '/home/guest_sign_in', to: 'static_pages#new_guest'
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
  resources :rewords do
    member do
      post :exchange
    end
  end
end
