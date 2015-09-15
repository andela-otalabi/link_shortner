Rails.application.routes.draw do
  root "links#index"
  get 'statistics/:id' => 'links#statistics', as: "statistics"
  get 'sorts' => 'links#sort', as: "sort"
  resources :links
  resources :users 
  
  get 'signup'  => 'users#new'
  get 'login'   => 'sessions#new'
  post 'login'   => 'sessions#create'
  delete 'logout'  => 'sessions#destroy'
  get ':short_link' => 'links#show'
end
