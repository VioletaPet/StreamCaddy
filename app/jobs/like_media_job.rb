class LikeMediaJob < ApplicationJob
  queue_as :default

  def perform(user_id, params)
    # Do something later
    params = params.with_indifferent_access
    media_result = TmdbService.search_tv_movie(params['title'] || params['name'])
    media_type = media_result['results'][0]['media_type']
    media_data = TmdbService.fetch_media_details(media_type, params[:id])
    media_seasons = TmdbService.fetch_tv_show_seasons(params[:id])
    Rails.logger.debug "Media Seasons: #{media_seasons.inspect}"
    seasons = media_seasons['seasons']
    cast_crew_data = TmdbService.fetch_cast_details(media_type, params[:id])
    Rails.logger.debug "Cast and Crew Data: #{cast_crew_data.inspect}"
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

    @media = MediaService.create_media_with_associations(media_data, cast_data, creator, watch_providers_data, media_type, poster_data, backdrops_data, video_data, seasons)

    user = User.find(user_id)
    @watchlist_media = user.watchlist_media.new(media: @media)
    @watchlist_media.save!
  end
end
