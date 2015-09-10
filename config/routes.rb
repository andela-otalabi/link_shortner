Rails.application.routes.draw do
  root "welcome#index"
  resources :links
  resources :users
  get ':short_link' => 'links#show'
  get 'signup'  => 'users#new'
  get 'login'   => 'sessions#new'
  post 'login'   => 'sessions#create'
  delete 'logout'  => 'sessions#destroy
end
