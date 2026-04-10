Rails.application.routes.draw do
  resources :users
  resources :recipes do
    resources :comments
  end
end
