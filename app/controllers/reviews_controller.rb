class ReviewsController < ApplicationController
  def show
    @review = Review.find(params[:id])
  end

  def new
    @watchlist_item = WatchlistMedium.find(params[:watchlist_medium_id])
    @review = @watchlist_item.reviews.build
  end

  def create
    @watchlist_item = WatchlistMedium.find(params[:watchlist_medium_id])
    @review = @watchlist_item.reviews.build(review_params)
    @review.user = current_user

    if @review.save
      redirect_to watchlist_media_path, notice: "Review has been added."
    else
      render :new, alert: "There was an error saving your review."
    end
  end

  private

  def review_params
    params.require(:review).permit(:rating, :content)
  end
end
