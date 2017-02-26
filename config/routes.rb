Rails.application.routes.draw do
  resources :sentences, only: [:index]
end
