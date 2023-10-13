Rottenpotatoes::Application.routes.draw do
  resources :movies
  # map '/' to be a redirect to '/movies'
  root :to => redirect('/movies')
  post '/movies/search_tmdb' => 'movies#search_tmdb', :as => 'search_tmdb'

  get 'auth/:provider/callback' => 'sessions#create' 
  get 'auth/failure' => 'sessions#failure'
  get 'auth/facebook', :as => 'login'
  post 'logout' => 'sessions#destroy'
end
