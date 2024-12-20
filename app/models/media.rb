class Media < ApplicationRecord
  has_many :media_watch_providers, dependent: :destroy
  has_many :watch_providers, through: :media_watch_providers
  has_many :media_genres, dependent: :destroy
  has_many :genres, through: :media_genres
  has_many :media_actors, dependent: :destroy
  has_many :actors, through: :media_actors
  has_many :watchlist_media
  has_many :users, through: :watchlist_media
  has_many :reviews, dependent: :destroy
  has_many :seasons
  has_many :episodes, through: :seasons
  has_many :progress_trackers
  has_one_attached :poster
  has_one_attached :video
  has_many_attached :backdrops

  def calculate_runtime(media)
    if media.category == 'tv'
      runtime = media.seasons.includes(:episodes).sum do |season|
        season.episodes.sum { |episode| episode.runtime.to_i > 0 ? episode.runtime.to_i : 45 }
      end
    else
      runtime = media[:run_time].to_i
    end
    media.update(run_time: runtime) if media.respond_to?(:runtime=)

    runtime
  end


end
