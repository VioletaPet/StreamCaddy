class Media < ApplicationRecord
  has_many :media_watch_providers
  has_many :genres, through: :media_genres
  has_many :actors, through: :media_actors
  has_many :users, through: :watchlist_media
  has_many :reviews
  has_many :seasons
  has_many :episodes, through: :seasons
  has_many :progress_trackers
end
