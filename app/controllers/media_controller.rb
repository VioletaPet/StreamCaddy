require_dependency '../services/tmdb_service.rb'

class MediaController < ApplicationController
  def index
    @movies = TmdbService.fetch_movies
    @tvshows = TmdbService.fetch_tv
  end

  def show

    media_id = params[:id]
    media_title = params[:title]

    @media = Media.find_by(api_id: media_id)

    if @media
      render 'show'
    else
      media_result = TmdbService.search_tv_movie(params[:title])
      first_result = media_result['results'][0]

      media_id = first_result['id']
      media_type = first_result['media_type']
      media_data = TmdbService.fetch_media_details(media_type, media_id)

      all_cast_data = TmdbService.fetch_cast_details(media_type, media_id)
      cast_data = all_cast_data['cast']
      crew_data = all_cast_data['crew']

      directors = crew_data.select { |member| member['job'] == 'Director'}
      directors.first['name']

      
      raise

      @media = Media.create(
        title: media_data['title'],
        category: media_type,
        synopsis: media_data['overview'],
        creator: director.first['name'],
        api_id: media_id,
        release_date: media_data['release_date'],
        run_time: media_data['runtime']
        )



    end

  end

  def new
    @media = Media.new
  end

  def create

  end

end
