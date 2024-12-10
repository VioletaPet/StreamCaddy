require_dependency '../services/tmdb_service.rb'


class MediaController < ApplicationController
  def index
    @movies = TmdbService.fetch_movies
  end
end
