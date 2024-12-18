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

  def calculate_media_scores
    watchlist_media.map do |watchlist_item|
      media_item = watchlist_item.media
      provider_type = determine_provider_type(media_item)

      {
        media_item: media_item,
        score: score_media_item(media_item, provider_type),
        runtime: media_item.calculate_runtime(media_item),
        provider_name: media_item.watch_providers.map(&:name)
      }
    end.sort_by { |entry| -entry[:score] }
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



  def avatar_url
    avatar.attached? ? avatar : 'https://www.hartz.com/wp-content/uploads/2022/04/small-dog-owners-1.jpg'
  end

  def group_by_provider(media_scores)
    provider_groups = Hash.new { |hash, key| hash[key] = { total_runtime: 0, total_score: 0, content: [] } }

    media_scores.each do |entry|
      entry[:provider_name].each do |provider|
        provider_groups[provider][:total_runtime] += entry[:runtime]
        provider_groups[provider][:total_score] += entry[:score]
        provider_groups[provider][:content] << entry
      end
    end
    provider_groups.sort_by { |_provider, data| -data[:total_score] }.to_h
  end

  def generate_watchlist(provider_groups, max_providers)
    provider_no = max_providers[:max_providers_per_month]
    monthly_schedule = []


    sorted_providers = provider_groups.sort_by { |_, data| -data[:total_score] }.to_h
    remaining_runtime = provider_groups.transform_values { |data| data[:total_runtime] }

    active_providers = sorted_providers.first(provider_no)
    month_index = 1
    while active_providers.any?
      month_data = { month: month_index, providers: [], total_runtime: 0 }

      active_providers.each do |provider|

        provider_name = provider.first
        content = provider.second[:content]
        provider_runtime = provider.second[:total_runtime]

        month_runtime = [remaining_runtime[provider_name], provider_runtime].min

        month_data[:providers] << {
          provider: provider_name,
          content: content,
          total_runtime: (month_runtime / 60.0).round(1)
        }

        month_data[:total_runtime] += provider_runtime / 60.0
        month_data[:total_runtime] += month_runtime / 60.0
        remaining_runtime[provider_name] -= month_runtime

      end
      active_providers.delete_if do |provider|
        provider_name = provider.first
        remaining_runtime[provider_name] <= 0
      end

      if active_providers.size < provider_no
        current_providers = active_providers.map { |p| p[0] }
        next_best_providers = sorted_providers.keys.reject do |provider_name|
          current_providers.include?(provider_name) || remaining_runtime[provider_name] <= 0
        end

        break if next_best_providers.empty? # Exit if no more providers available

        next_best_providers.first(provider_no - active_providers.size).each do |next_provider|
          active_providers << [next_provider, sorted_providers[next_provider]]
        end
      end

      monthly_schedule << month_data

      month_index += 1

    end
    monthly_schedule
  end


private

  def determine_provider_type(media_item)

    media_watch_provider = media_item.media_watch_providers.find_by(watch_provider_id: media_item.watch_providers.pluck(:id))
    return 'free' if media_watch_provider&.flatrate
    return 'rent' if media_watch_provider&.rent
    return 'paid' if media_watch_provider&.buy
    'unknown'
  end
end
