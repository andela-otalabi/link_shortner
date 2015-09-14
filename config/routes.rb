Rails.application.routes.draw do
  root "welcome#index"
  get 'statistics/:id' => 'links#statistics', as: "statistics"
  resources :links
  resources :users do
    resources :links
  end
  
  get 'signup'  => 'users#new'
  get 'login'   => 'sessions#new'
  post 'login'   => 'sessions#create'
  delete 'logout'  => 'sessions#destroy'
  get ':short_link' => 'links#show'
end
