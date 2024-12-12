class GamesController < ApplicationController
  def index
    @user_providers = current_user.watch_providers.pluck(:api_id)
    watchlist_ids = current_user.watchlist_media.pluck(:media_id)

    media_type = ['movie', 'tv'].sample

    media_results = TmdbService.fetch_random_media(media_type, @user_providers)

    filtered = media_results.reject { |media| watchlist_ids.include?(media['id']) }
    @random_media = filtered.sample
  end

  def like
  end
end
