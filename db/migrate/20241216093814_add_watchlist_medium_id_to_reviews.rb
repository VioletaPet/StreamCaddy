class AddWatchlistMediumIdToReviews < ActiveRecord::Migration[7.1]
  def change
    add_column :reviews, :watchlist_medium_id, :integer
  end
end
