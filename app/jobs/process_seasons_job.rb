class ProcessSeasonsJob < ApplicationJob
  queue_as :default

  def perform(media_id, seasons)
    # Do something later
    media = Media.find(media_id)
    return if !seasons || media.seasons.any?

    seasons.each do |s|
      season = Season.create!(
        media_id: media.id,
        number: s['season_number'],
        no_of_episodes: s['episode_count'],
        synopsis: s['overview'],
        name: s['name']
      )
      if s['poster_path']
        poster_url = "https://image.tmdb.org/t/p/original#{s['poster_path']}"
        season.poster.attach(io: URI.open(poster_url), filename: File.basename(poster_url), content_type: 'image/jpeg')
      end

      episodes_url = URI("https://api.themoviedb.org/3/tv/#{media.api_id}/season/#{s['season_number']}?language=en-US")

      http = Net::HTTP.new(episodes_url.host, episodes_url.port)
      http.use_ssl = true

      request = Net::HTTP::Get.new(episodes_url)
      request["accept"] = 'application/json'
      request["Authorization"] = "Bearer #{API_KEY}"

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
    end
  end
end
