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

  def self.watch_providers(provider)
    require 'uri'
    require 'net/http'

    if provider.count == 1
      url = URI("https://api.themoviedb.org/3/discover/movie?include_adult=false&include_video=false&language=en-US&page=1&sort_by=popularity.desc&with_watch_providers=#{provider[0]}&watch_region=US")
    else
      source = provider[0]
      provider.delete_at(0)
      provider.each do |p|
        source += "%7C#{p}"
      end
      url = URI("https://api.themoviedb.org/3/discover/movie?include_adult=false&include_video=false&language=en-US&page=1&sort_by=popularity.desc&with_watch_providers=#{source}&watch_region=US")
    end



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
