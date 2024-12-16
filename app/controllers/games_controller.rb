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
    @media = Media.find_by(api_id: params[:id])
    if @media
      current_user.watchlist_media.create(media: @media)
      redirect_to game_path
    else
      LikeMediaJob.perform_later(current_user.id, media_params)
      redirect_to game_path, notice: "Item is being added to your watchlist"
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

  private

  def media_params
    params.permit(:title, :name, :id)
  end
end
