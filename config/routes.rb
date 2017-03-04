Rails.application.routes.draw do
  resources :sentences, only: [:index]
  root to: "welcome#index"
end
