Rails.application.routes.draw do
  resource :user, only: [:new, :create, :show]
  resource :session, only: [:new, :create, :destroy]

  resources :subs, except: :destroy

  resources :posts, except: :index do
    resources :comments, only: :new
  end

  resources :comments, only: [:create, :show]

  root to: 'subs#index'
end
