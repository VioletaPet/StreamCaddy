require_dependency '../services/tmdb_service.rb'

class MediaController < ApplicationController
  def index
    @movies = TmdbService.fetch_movies
  end

  def new

  end

  def search
    provider_id = params[:search][:provider].drop(1)

    @movies = TmdbService.watch_providers(provider_id)

  end

  private

end
