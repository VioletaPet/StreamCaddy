class User < ApplicationRecord
  has_one_attached :avatar
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :user_providers
  has_many :watch_providers, through: :user_providers
  has_many :watchlist_media
  has_many :medias, through: :watchlist_media
  has_many :media_genres, through: :medias
  has_many :genres, through: :media_genres
  has_many :seasons, through: :medias
  has_many :episodes, through: :seasons
  validates :first_name, :last_name, presence: true
  validates :email, :username, uniqueness: true
  has_many :user_genre_weights
  has_many :user_creator_weights

  def recalculate_weights
    genre_counts = watchlist_media.flat_map { |m| m.media.genres.map(&:name) }.tally
    total_genres = genre_counts.values.sum

    @genre_weights = genre_counts.transform_values do |count|
      ((count.to_f / total_genres) * 100).round(2)
    end

    creator_counts = watchlist_media.map { |m| m.media.creator }.compact_blank.tally
    total_creators = creator_counts.values.sum

    @creator_weights = creator_counts.transform_values do |count|
      ((count.to_f / total_creators) * 100).round(2)
    end

  end

  def genre_weights
    recalculate_weights if @genre_weights.nil?
    @genre_weights
  end

  def creator_weights
    recalculate_weights if @creator_weights.nil?
    @creator_weights
  end

  def update_watchlist_scores
    watchlist_media.includes(:media).each do |watchlist_item|
      media_item = watchlist_item.media
      provider_type = determine_provider_type(media_item)

      new_score = score_media_item(media_item, provider_type)
      media_item.update(score: new_score) if media_item.respond_to?(:score)
    end
  end


  def score_media_item(media_item, provider_type)
    genre_score = media_item.genres.sum do |genre|
      genre_rank = genre_weights.keys.index(genre.name)
      genre_rank ? [5 - genre_rank, 0].max : 0
    end

    creator_rank = creator_weights.keys.index(media_item.creator)
    creator_score = if creator_rank && creator_rank < 5
                      [10, 7.5, 5, 2.5, 1][creator_rank]
                    else
                      0.5
                    end

    provider_score = case provider_type
                      when 'free' then 10
                      when 'rent' then -2
                      when 'paid' then -5
                      when 'unreleased' then 0
                      else 0
                      end

    genre_score + creator_score + provider_score
  end

  def calculate_scores
    watchlist_media.map do |watchlist_item|
      media_item = watchlist_item.media
      {
        media_item: media_item,
        score: score_media_item(media_item)
      }
    end.sort_by { |entry| -entry[:score] }
  end


  def provider_scores

    provider_totals = Hash.new(0)

    watchlist_media.each do |watchlist_item|
      media_item = watchlist_item.media
      media_score = score_media_item(media_item)


      media_item.watch_providers.each do |provider|
        provider_totals[provider.name] += media_score
      end
    end

    provider_totals.sort_by { |_provider, total_score| -total_score }.to_h
  end




  def avatar_url
    avatar.attached? ? avatar : 'https://www.hartz.com/wp-content/uploads/2022/04/small-dog-owners-1.jpg'
  end
end

private

def determine_provider_type(media_item)
  # Check for the provider type in media_watch_providers
  media_watch_provider = media_item.media_watch_providers.find_by(watch_provider_id: media_item.watch_providers.pluck(:id))
  return 'free' if media_watch_provider&.flatrate
  return 'rent' if media_watch_provider&.rent
  return 'paid' if media_watch_provider&.buy
  'unknown'
end
