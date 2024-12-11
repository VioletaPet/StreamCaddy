require_dependency '../services/tmdb_service.rb'

class MediaController < ApplicationController
  def index
    @movies = TmdbService.fetch_movies
    @tvshows = TmdbService.fetch_tv
  end

  def show

    @media_id = params[:id]
    @media_title = params[:title]

    @media = Media.find_by(api_id: @media_id)

    if @media
      render 'show'
    else
      redirect_to new_media_path(id: params[:id], title: params[:title])
    end

  end

  def new
    @media = Media.new
  end

  def create
    media_result = TmdbService.search_tv_movie(params['title'])
    media_type = media_result['results'][0]['media_type']
    media_data = TmdbService.fetch_media_details(media_type, params[:id])
    cast_crew_data = TmdbService.fetch_cast_details(media_type, params[:id])
    cast_data = cast_crew_data['cast']
    crew_data = cast_crew_data['crew']
    if media_type == 'movie'
      creator = crew_data.select { |member| member['job'] == 'Director' }.first
    else
      creator = crew_data.sort_by { |crew_data| -crew_data['popularity'] }.first
    end
    watch_providers_data = TmdbService.fetch_media_watch_providers(media_type, params[:id])['results']['GB']
    photo_data = TmdbService.fetch_media_images(media_type, params[:id])
    poster_data = photo_data['posters'][0]
    backdrops_data = photo_data['backdrops'].first(10)
    video_data = TmdbService.fetch_media_videos(media_type, params[:id])['results']
    filtered_videos = video_data.select do |video|
      video['type'] == 'Trailer' && video['official'] && video['site'] == 'YouTube'
    end
    sorted_videos = filtered_videos.sort_by do |video|
      [-video['size'], video['published_at']]
    end
    best_video = sorted_videos.first
    if best_video
      video_data = best_video
    else
      video_data.first
    end

    @media = MediaService.create_media_with_associations(media_data, cast_data, creator, watch_providers_data, media_type, poster_data, backdrops_data, video_data)

    render 'show'
  end


  def search
    provider_id = params[:search][:provider]
    provider_id.delete_at(0)

    @media = TmdbService.watch_providers(provider_id)

  end

  private

end
