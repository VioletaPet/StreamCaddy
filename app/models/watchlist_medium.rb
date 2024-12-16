class WatchlistMedium < ApplicationRecord
  belongs_to :user
  belongs_to :media

  validates :user_id, uniqueness: { scope: :media_id }

  after_save :recalculate_and_update_scores
  after_destroy :recalculate_and_update_scores

  private

  def recalculate_and_update_scores
    user.recalculate_weights
    user.update_watchlist_scores
  end

end
