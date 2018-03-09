Rails.application.routes.draw do
  #get 'sessions/new' #is this supposed to be here? 
  # WATCH - commenting out for now, as of 9.2

  root 'static_pages#home'
  #get '/home', to: 'static_pages/home'
  get    '/help',    to: 'static_pages#help'
  get    '/about',   to: 'static_pages#about'
  get    '/contact', to: 'static_pages#contact'
  get    '/signup',  to: 'users#new'
  post   '/signup',  to: 'users#create'
  resources :users
  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'
  #patch  '/users/:id/edit', to: 'users#edit'
end