class RemoveWatchlistMediumIdFromReviews < ActiveRecord::Migration[7.1]
  def change
    remove_column :reviews, :watchlist_medium_id, :integer
  end
end
