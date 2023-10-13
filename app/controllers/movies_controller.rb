class MoviesController < ApplicationController
  before_action :force_index_redirect, only: [:index]
  Tmdb::Api.key(ENV["TMDB_API_KEY"])
  

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index      
    #@all_ratings = Movie.all_ratings
    @movies = Movie.with_ratings(ratings_list, sort_by)
    @ratings_to_show_hash = ratings_hash
    @sort_by = sort_by
    # remember the correct settings for next time
    session['ratings'] = ratings_list
    session['sort_by'] = @sort_by
  end

  def new
    # default: render 'new' template
    # if access by search name from tdmb do
    if params[:movie]
      @movie = Movie.new(movie_params)
    end
    #title_name = params[:title]
    #@release_date = params[:release_date].split("-")
    #@release_date = params[:release_date]
    #, default: {day: @release_date[2],month: @release_date[1],year: @release_date[0]}
    #, :value =>@title_name
    #byebug
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

  def search_tmdb
    #get parameter from search form by tag :movie :title
    movie_name = params[:movie][:title]
    #Search movie by name
    @movie = Tmdb::Movie.find(movie_name)
    #Checking Search Found
    if @movie != []
      redirect_found_tmdb(@movie)
    else
      flash[:notice] = "'#{movie_name}' was not found in TMDb."
      redirect_to movies_path
    end
    
  end

  
  private
  
  def redirect_found_tmdb(movie)
    @movie = movie[0]
    redirect_to new_movie_path(
        movie: {title: @movie.original_title, release_date: @movie.release_date}
        )
  end

  def force_index_redirect
    if !params.key?(:ratings) || !params.key?(:sort_by)
      flash.keep
      url = movies_path(sort_by: sort_by, ratings: ratings_hash)
      redirect_to url
    end
  end

  def ratings_list
    params[:ratings]&.keys || session[:ratings] || Movie.all_ratings
  end

  def ratings_hash
    Hash[ratings_list.collect { |item| [item, "1"] }]
  end

  def sort_by
    params[:sort_by] || session[:sort_by] || 'id'
  end

  

  
    # Making "internal" methods private is not required, but is a common practice.
    # This helps make clear which methods respond to requests, and which ones do not.
  def movie_params
      params.require(:movie).permit(:title, :rating, :description, :release_date)
  end
end
