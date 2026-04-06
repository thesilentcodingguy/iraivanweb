Rails.application.routes.draw do
  devise_for :users

  authenticated :user do
    root "posts#index", as: :authenticated_root
  end

  unauthenticated do
    root to: redirect("/users/sign_in")
  end

  resources :posts
  get "my_posts", to: "posts#my_posts"
end
