class MoviesController < ApplicationController

  @@sort_columns = { 'title' => true,
    'rating' => true,
    'description' => true,
    'release_date' => true}
  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.all_ratings
    used_session_params = false
    @sort = params[:sort]
    if @sort
      session[:sort] = @sort
    else
      @sort = session[:sort]
      if ! @sort
        @sort = 'id'
      end
      used_session_params = true
    end
    @ratings = params[:ratings]
    if ! @ratings
      @ratings = { }
    end
    if ! @ratings.empty? || params[:commit]
      session[:ratings] = @ratings
    else
      @ratings = session[:ratings]
      if ! @ratings
        @ratings = { }
      end
      used_session_params = true
    end
    if used_session_params
      redirect_to movies_path({ :sort => @sort,
                                :ratings => @ratings,
                                :commit => 'Refresh' })
    else
      where = {}
      if @ratings && ! @ratings.empty?
        where[:rating] = @ratings.keys
      end
      @ratings_params = { }
      @ratings.each{ |key, value| @ratings_params["ratings[#{key}]"] = value }
      logger.debug("ratings=#{@ratings}")
      logger.debug("where=#{where}")
      if where.empty?
        @movies = Movie.order(@sort).all
      else
        @movies = Movie.order(@sort).where(where)
      end
    end
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
