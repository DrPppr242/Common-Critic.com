CommonCriticCom::Application.routes.draw do
  # Sessions
  get "sessions/new"
  get "sessions/create"
  get "sessions/destroy"

  # Resources
  resources :users

end
