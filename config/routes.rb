Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'users/registrations', omniauth_callbacks: 'users/omniauth_callbacks' }

  devise_scope :user do
    post 'users/guest_sign_in', to: 'users/sessions#guest_sign_in'
    delete 'users/sign_out', to: 'users/sessions#destroy'
  end

  root to: 'home#index'
  
  get 'users/confirm_email', to: 'confirmations#new', as: :confirm_email
  post 'users/confirm_email', to: 'confirmations#create'


  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end
end
