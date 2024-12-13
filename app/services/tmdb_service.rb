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

  def self.watch_providers_movies(provider)

    if provider.any?
      source = provider.join("7%C")
      url = URI("https://api.themoviedb.org/3/discover/movie?include_adult=false&include_video=false&language=en-US&page=1&sort_by=popularity.desc&with_watch_providers=#{source}&watch_region=GB")
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

  def self.watch_providers_tv(provider)

    if provider.any?
      source = provider.join("7%C")
      url = URI("https://api.themoviedb.org/3/discover/tv?include_adult=false&include_null_first_air_dates=false&language=en-US&page=1&sort_by=popularity.desc&with_watch_providers=#{source}&watch_region=GB")
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

  def self.fetch_media_watch_providers(media_type, media_id)
    url = URI("https://api.themoviedb.org/3/#{media_type}/#{media_id}/watch/providers")

    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true

    request = Net::HTTP::Get.new(url)
    request["accept"] = 'application/json'
    request["Authorization"] = "Bearer #{API_KEY}"

    response = http.request(request)
    JSON.parse(response.read_body)
  end

  def self.fetch_media_images(media_type, media_id)
    url = URI("https://api.themoviedb.org/3/#{media_type}/#{media_id}/images")

    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true

    request = Net::HTTP::Get.new(url)
    request["accept"] = 'application/json'
    request["Authorization"] = "Bearer #{API_KEY}"

    response = http.request(request)
    JSON.parse(response.read_body)
  end

  def self.fetch_media_videos(media_type, media_id)
    url = URI("https://api.themoviedb.org/3/#{media_type}/#{media_id}/videos?language=en-US")

    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true

    request = Net::HTTP::Get.new(url)
    request["accept"] = 'application/json'
    request["Authorization"] = "Bearer #{API_KEY}"

    response = http.request(request)
    JSON.parse(response.read_body)
  end

  def self.fetch_cast_member_details(member_id)
    url = URI("https://api.themoviedb.org/3/person/#{member_id}?language=en-US")

    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true

    request = Net::HTTP::Get.new(url)
    request["accept"] = 'application/json'
    request["Authorization"] = "Bearer #{API_KEY}"

    response = http.request(request)
    JSON.parse(response.read_body)
  end

  def self.fetch_random_media(media_type, providers)

    random_page = rand(1..100)
    url = URI("https://api.themoviedb.org/3/discover/#{media_type}?language=en-US&sort_by=popularity.desc&page=#{random_page}&watch_region=GB")

    url.query += "&with_watch_providers=#{providers.join("|")}" if providers.any?

    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true

    request = Net::HTTP::Get.new(url)
    request["accept"] = 'application/json'
    request["Authorization"] = "Bearer #{API_KEY}"

    response = http.request(request)
    JSON.parse(response.body)['results']
  end
end
