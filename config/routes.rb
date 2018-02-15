Rails.application.routes.draw do
  get 'home/index'

  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks'}

  authenticated :user do
    root 'home#index', as: 'authenticated_root'
  end

  devise_scope :user do
    root 'devise/sessions#new'
  end
end
