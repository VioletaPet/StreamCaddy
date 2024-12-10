require 'uri'
require 'net/http'
require 'json'

class TmdbService

  API_KEY = ENV['TMDB_API_KEY']


  def self.fetch_movies
    url = URI("https://api.themoviedb.org/3/movie/popular?language=en-US&page=1")

    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true

    request = Net::HTTP::Get.new(url)
    request["accept"] = 'application/json'
    request["Authorization"] = "Bearer #{API_KEY}"

    response = http.request(request)
    json_response = JSON.parse(response.read_body)
    json_response['results']
  end

end
