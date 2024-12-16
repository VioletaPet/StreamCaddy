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
    genre_counts = watchlist_media.flat_map { |m| m.media.genres.pluck(:name) }.tally
    total_genres = genre_counts.values.sum

    @genre_weights = genre_counts.transform_values { |count| ((count.to_f / total_genres) * 100).round(2) }
                               .sort_by { |_genre, percentage| -percentage }
                               .to_h


    creator_counts = watchlist_media.map { |m| m.media.creator.presence }.compact.tally
    total_creators = creator_counts.values.sum

    @creator_weights = creator_counts.transform_values { |count| ((count.to_f / total_creators) * 100).round(2) }
    .sort_by { |_creator, percentage| -percentage }
    .to_h

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

    watchlist_media.includes(:media, media: :watch_providers).each do |watchlist_item|
      media_item = watchlist_item.media
      provider_type = determine_provider_type(media_item)
      media_score = score_media_item(media_item, provider_type)

      media_item.watch_providers.each do |provider|
        provider_totals[provider.name] += media_score
      end
    end

    provider_totals.sort_by { |_provider, total_score| -total_score }.to_h
  end

  def suggest_content_schedule(selected_platforms, user_providers)
    provider_data = Hash.new { |hash, key| hash[key] = { content: [], total_score: 0, total_runtime: 0 } }

    watchlist_media.includes(media: :watch_providers).each do |watchlist_item|
      media_item = watchlist_item.media
      runtime = media_item.media_run_time

      media_item.watch_providers.each do |provider|
        provider_name = provider.name
        provider_id = provider.id

        provider_score = score_media_item(media_item, determine_provider_type(media_item))
        provider_data[provider_id][:content] << {
          media: media_item,
          score: provider_score,
          runtime: runtime,
          provider_name: provider_name,
          subscribed: user_providers.include?(provider_id)
        }

        provider_data[provider_id][:total_score] += provider_score
        provider_data[provider_id][:total_runtime] += runtime
      end
    end

    sorted_providers = provider_data.sort_by { |_provider, data| [-data[:total_score], -data[:total_runtime]] }.to_h

    selected_providers = sorted_providers.keys.first(selected_platforms)

    build_subscription_schedule(selected_providers, provider_data, user_providers)
  end

  def avatar_url
    avatar.attached? ? avatar : 'https://www.hartz.com/wp-content/uploads/2022/04/small-dog-owners-1.jpg'
  end


private

  def determine_provider_type(media_item)

    media_watch_provider = media_item.media_watch_providers.find_by(watch_provider_id: media_item.watch_providers.pluck(:id))
    return 'free' if media_watch_provider&.flatrate
    return 'rent' if media_watch_provider&.rent
    return 'paid' if media_watch_provider&.buy
    'unknown'
  end

  def build_subscription_schedule(selected_providers, provider_data, user_providers)
    schedule = []
    monthly_runtime = 7200
    month = 1

    provider_content = provider_data.map { |provider, data| [provider, data[:content].dup] }.to_h

    scheduled_content_ids = Set.new
    
    while provider_content.values.flatten.any?
      month_content = []
      remaining_runtime = monthly_runtime
      suggested_provider = nil

      (selected_providers + provider_content.keys).uniq.each do |provider|
        next if provider_content[provider].blank?

      content_to_remove = []

      provider_content[provider].each do |item|
        break if remaining_runtime <= 0

        if item[:runtime] <= remaining_runtime
          month_content << {
            media: item[:media],
            runtime: item[:runtime],
            score: item[:score],
            provider: provider,
            subscribed: user_providers.include?(provider)
          }
          remaining_runtime -= item[:runtime]
          content_to_remove << item
        else
          partial_runtime = remaining_runtime
          remaining_runtime = 0

          month_content << {
            media: item[:media],
            runtime: partial_runtime,
            score: item[:score],
            provider: item[:provider_name],
            subscribed: user_providers.include?(provider),
            continued: true
          }
          item[:runtime] -= partial_runtime
          break
        end
      end

      provider_content[provider] -= content_to_remove
      suggested_provider ||= provider unless user_providers.include?(provider)
      break if remaining_runtime <= 0
    end

    if month_content.any?
      schedule << { month: month, content: month_content, suggested_provider: suggested_provider }
      month += 1
    else
      break
    end
  end

  schedule
end

end
