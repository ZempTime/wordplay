Wordplay::Application.routes.draw do
  resources :entries
  root to: 'entries#index'
end
