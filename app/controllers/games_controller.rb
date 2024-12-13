class GamesController < ApplicationController
  def index
    load_random_media
    respond_to do |format|
      format.html
      format.turbo_stream
    end
  end



  def like
    load_random_media
    MediaCreationJob.perform_later(like_params.to_h, current_user.id)

    respond_to do |format|
      format.html { redirect_to game_path, notice: "Processing your like... New content loading!" }
      format.turbo_stream
    end
  end



  def dislike
    session[:disliked_media_ids] ||= []
    session[:disliked_media_ids] << params[:id].to_i unless session[:disliked_media_ids].include?(params[:id].to_i)

    load_random_media

    respond_to do |format|
      format.html { redirect_to game_path }
      format.turbo_stream
    end
  end

  def skip
    load_random_media

    respond_to do |format|
      format.html { redirect_to game_path }
      format.turbo_stream
  end
end

private

  def load_random_media
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

  def like_params
    params.permit(:id, :title, :name)
  end
end
