require 'open-uri'
class MediaService

  def self.create_media_with_associations(media_data, cast_data, creator, watch_providers_data, media_type, poster_data, backdrops_data, video_data)
    ActiveRecord::Base.transaction do

      media = Media.find_or_create_by(api_id: media_data['id']) do |m|
        m.title = media_data['title'] || m.title = media_data['name']
        m.category = media_type
        m.synopsis = media_data['overview']
        m.creator = creator['name']
        m.release_date = media_data['release_date'] || m.release_date = media_data['first_air_date']
        m.run_time = media_data['runtime']

        if poster_data
          poster_url = "https://image.tmdb.org/t/p/original#{poster_data['file_path']}"
          m.poster.attach(io: URI.open(poster_url), filename: File.basename(poster_url), content_type: 'image/jpeg')
        end
        if backdrops_data
          backdrops_data.each do |backdrop|
            backdrop_url = "https://image.tmdb.org/t/p/original#{backdrop['file_path']}"
            m.backdrops.attach(io: URI.open(backdrop_url), filename: File.basename(backdrop_url), content_type: 'image/jpeg')
          end
        end
      end



      create_cast_associations(media, cast_data)
      create_genre_associations(media, media_data['genres'])
      create_watch_provider_associations(media, watch_providers_data)

      media
    end
  rescue ActiveRecord::RecordInvalid => e
    Rails.logger.error("Failed to create media and associations: #{e.message}")
    nil
  end

  private

  # def self.attach_video_to_media
  #   need more knowledge on handling videos
  # end
  def self.create_cast_associations(media, cast_data)
    return unless cast_data
    cast_data.each do |cast_member|
      member_details = TmdbService.fetch_cast_member_details(cast_member['id'])
      actor = Actor.find_or_create_by(api_id: cast_member['id']) do |a|
        a.name = cast_member['name']
        a.bio = member_details['biography']
      end
      MediaActor.create!(media_id: media['id'], actor_id: actor['id'] , character: cast_member['character'])
    end
  end

  def self.create_genre_associations(media, genre_data)
    genre_data.each do |genre|
      genre_record = Genre.find_by(name: genre['name'])
      MediaGenre.create!(media_id: media['id'], genre_id: genre_record['id'])
    end
  end

  def self.create_watch_provider_associations(media, watch_providers_data)
    return unless watch_providers_data

    all_providers = %w[flatrate buy rent].flat_map do |provider_type|
      next unless watch_providers_data[provider_type]
      watch_providers_data[provider_type].map do |provider|
        { provider: provider, type: provider_type }
      end
    end.compact

    all_providers.each do |provider_data|
      provider = provider_data[:provider]
      type = provider_data[:type]


      watch_provider = WatchProvider.find_by(name: provider['provider_name'])

      unless watch_provider
        Rails.logger.warn("WatchProvider not found for: #{provider['provider_name']}")
        next
      end


      media_watch_provider = MediaWatchProvider.find_or_initialize_by(
        media_id: media.id,
        watch_provider_id: watch_provider.id
      )


      media_watch_provider.flatrate ||= (type == 'flatrate')
      media_watch_provider.buy ||= (type == 'buy')
      media_watch_provider.rent ||= (type == 'rent')

    end
  end
end
