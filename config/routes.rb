Rails.application.routes.draw do
  
  resources :playlists

  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }
  
  resources :pages

  root 'pages#index'
  
end
