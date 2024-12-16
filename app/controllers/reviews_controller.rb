class ReviewsController < ApplicationController
  def show
    @review = Review.find(params[:id])
  end

  def new
    @watchlist_item = Media.find(params[:medium_id])
    @review = @watchlist_item.reviews.new
  end

  def create
    @watchlist_item = Media.find(params[:medium_id])
    @review = @watchlist_item.reviews.new(review_params)
    @review.user = current_user

    if @review.save
      redirect_to medium_path(@watchlist_item.api_id), notice: "Review successfully added!"
    else
      render :new, alert: "There was an error saving your review."
    end
  end

  private

  def review_params
    params.require(:review).permit(:rating, :content)
  end
end
