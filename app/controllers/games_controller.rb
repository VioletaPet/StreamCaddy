class GamesController < ApplicationController
  def index
    @user_providers = current_user.watch_providers.pluck(:api_id)
    watchlist_ids = current_user.watchlist_media.pluck(:media_id)
    disliked_ids = session[:disliked_media_ids] || []

    media_type = ['movie', 'tv'].sample

    media_results = TmdbService.fetch_random_media(media_type, @user_providers)

    filtered = media_results.reject do |media|
      watchlist_ids.include?(media['id'] || disliked_ids.include?(media['id']))
    end
    @random_media = filtered.sample
  end

  def like
    # to create a new media object from the params
    media_result = TmdbService.search_tv_movie(params['title'] || params['name'])
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

    # to create a new watchlist_media object with the media object

    @watchlist_media = current_user.watchlist_media.new(media: @media)
    if @watchlist_media.save
      redirect_to game_path, notice: "Item has been added to your watchlist"
    else
      redirect_to games_path, alert: 'Failed to add item to your Watchlist'
    end
  end

  def dislike
    session[:disliked_media_ids] ||= []
    session[:disliked_media_ids] << params[:id].to_i unless session[:disliked_media_ids].include?(params[:id].to_i)
    redirect_to game_path
  end

  def skip
    redirect_to game_path
  end
end
