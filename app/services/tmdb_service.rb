require 'uri'
require 'net/http'
require 'json'

class TmdbService

  API_KEY = ENV['TMDB_API_KEY']


  def self.fetch_movies
    url = URI("https://api.themoviedb.org/3/discover/movie?include_adult=false&include_video=false&language=en-US&page=1&sort_by=popularity.desc&with_original_language=en")

    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true

    request = Net::HTTP::Get.new(url)
    request["accept"] = 'application/json'
    request["Authorization"] = "Bearer #{API_KEY}"

    response = http.request(request)
    json_response = JSON.parse(response.read_body)
    json_response['results']
  end

  def self.watch_providers(page_number, user_providers)
    require 'uri'
    require 'net/http'

    url = URI("https://api.themoviedb.org/3/discover/tv?include_adult=false&include_null_first_air_dates=false&language=en-US&page=#{page_number}&sort_by=popularity.desc&with_watch_providers=#{user_providers}")

    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true

    request = Net::HTTP::Get.new(url)
    request["accept"] = 'application/json'
    request["Authorization"] = "Bearer #{API_KEY}"

    response = http.request(request)
    json_response = JSON.parse(response.read_body)
    json_response['results']
  end


  def self.fetch_media_details(media_type, media_id)
    url = URI("https://api.themoviedb.org/3/#{media_type}/#{media_id}")
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true

    request = Net::HTTP::Get.new(url)
    request["accept"] = 'application/json'
    request["Authorization"] = "Bearer #{API_KEY}"

    response = http.request(request)
    JSON.parse(response.read_body)
  end

  def self.fetch_tv
    url = URI("https://api.themoviedb.org/3/discover/tv?include_adult=false&include_null_first_air_dates=false&language=en-US&page=1&sort_by=popularity.desc&with_original_language=en")

    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true

    request = Net::HTTP::Get.new(url)
    request["accept"] = 'application/json'
    request["Authorization"] = "Bearer #{API_KEY}"

    response = http.request(request)
    json_response = JSON.parse(response.read_body)
    json_response['results']
  end

  def self.search_tv_movie(media_title)
    url = URI("https://api.themoviedb.org/3/search/multi?query=#{media_title}&include_adult=false&language=en-US&page=1")

    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true

    request = Net::HTTP::Get.new(url)
    request["accept"] = 'application/json'
    request["Authorization"] = "Bearer #{API_KEY}"

    response = http.request(request)
    JSON.parse(response.read_body)
  end

  def self.fetch_cast_details(media_type, media_id)

    url = URI("https://api.themoviedb.org/3/#{media_type}/#{media_id}/credits?language=en-US")

    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true

    request = Net::HTTP::Get.new(url)
    request["accept"] = 'application/json'
    request["Authorization"] = "Bearer #{API_KEY}"

    response = http.request(request)
    JSON.parse(response.read_body)
  end



end
