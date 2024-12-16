class WatchlistMediaController < ApplicationController
  def index
    @watchlist = current_user.watchlist_media.includes(:media)
  end

  def show
    @watchlist_media = current_user.watchlist_media.find(params[:id])
  end

  def create
    @media = Media.find(params[:media_id])

    @watchlist_media = current_user.watchlist_media.new(media: @media)
    if @watchlist_media.save
      redirect_to watchlist_media_path(@watchlist_media), notice: "Item has been added to your watchlist"
    else
      redirect_to watchlist_media_path, alert: 'Failed to add item to your Watchlist'
    end
  end

  def destroy
    @watchlist_media = current_user.watchlist_media.find(params[:id])
    @watchlist_media.destroy
    redirect_to watchlist_media_path, status: :see_other
  end
end
