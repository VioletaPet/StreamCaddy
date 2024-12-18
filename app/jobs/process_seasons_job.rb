class ProcessSeasonsJob < ApplicationJob
  queue_as :default

  def perform(media_id, seasons)
    media = Media.find(media_id)
    return unless seasons.present? && media.api_id.present?

    seasons.each do |s|
      next if media.seasons.exists?(number: s['season_number'])

      # Create Season
      begin
        season = Season.create!(
          media_id: media.id,
          number: s['season_number'],
          no_of_episodes: s['episode_count'],
          synopsis: s['overview'],
          name: s['name']
        )
        Rails.logger.info "Season #{s['season_number']} created successfully"
      rescue StandardError => e
        Rails.logger.error "Failed to create Season #{s['season_number']}: #{e.message}"
        next
      end

      # Attach Season Poster
      if s['poster_path']
        poster_url = "https://image.tmdb.org/t/p/original#{s['poster_path']}"
        season.poster.attach(io: URI.open(poster_url), filename: File.basename(poster_url), content_type: 'image/jpeg')
      end

      # Fetch and Create Episodes
      episodes_url = URI("https://api.themoviedb.org/3/tv/#{media.api_id}/season/#{s['season_number']}?language=en-US")
      sleep(1) # Avoid rate-limiting

      begin

        api_key = ENV['TMDB_API_KEY']

        http = Net::HTTP.new(episodes_url.host, episodes_url.port)
        http.use_ssl = true

        request = Net::HTTP::Get.new(episodes_url)
        request["accept"] = 'application/json'
        request["Authorization"] = "Bearer #{api_key}"

        episodes_response = http.request(request)
        episodes_data = JSON.parse(episodes_response.read_body)

        episodes_data["episodes"].each do |episode|
          Episode.create!(
            season_id: season.id,
            number: episode['episode_number'],
            name: episode['name'],
            synopsis: episode['overview'],
            runtime: episode['runtime']
          )
        end
        Rails.logger.info "Episodes for Season #{season.number} created successfully"
      rescue StandardError => e
        Rails.logger.error "Failed to fetch or create episodes for Season #{s['season_number']}: #{e.message}"
      end
    end
  end

end
