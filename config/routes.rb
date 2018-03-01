Rails.application.routes.draw do
  get 'home/index'

  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks'}

  authenticated :user do
    root 'posts#index', as: 'authenticated_root'
  end

  devise_scope :user do
    root 'devise/sessions#new'
  end

  resources :comments, only: [:create]
  resources :likes, only: [:create, :destroy]
  resources :users, only: [:show, :index]
  resources :posts, only: [:show, :index, :create]
  resources :friendships, only: [:index, :create, :update, :destroy]

  get '*path' => redirect('/')
end
