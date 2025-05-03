Rails.application.routes.draw do
  get 'messages/create'
  get 'conversations/index'
  get 'conversations/show'
  get 'rakuten_searches/index'
  resources :submissions
  devise_for :users, controllers: { registrations: 'users/registrations', omniauth_callbacks: 'users/omniauth_callbacks' }

  devise_scope :user do
    post 'users/guest_sign_in', to: 'users/sessions#guest_sign_in'
    delete 'users/sign_out', to: 'users/sessions#destroy'
    get 'users/sns_sign_up', to: 'users/registrations#sns_sign_up', as: :sns_sign_up
  end

  resources :conversations, only: [:index, :show] do
    resources :messages, only: [:create]
  end
  mount ActionCable.server => '/cable'

  resources :rakuten_searches, only: [:index]

  root to: 'home#index'
  
  get 'users/confirm_email', to: 'confirmations#new', as: :confirm_email
  post 'users/confirm_email', to: 'confirmations#create'


  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end
end
