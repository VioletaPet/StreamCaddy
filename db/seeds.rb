require 'open-uri'
# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
UserProvider.destroy_all
MediaGenre.destroy_all
WatchlistMedium.destroy_all
User.destroy_all
Genre.destroy_all
WatchProvider.destroy_all
Media.destroy_all


#   end
7.times do
  first_name = Faker::Name.first_name
  last_name = Faker::Name.last_name
  username = Faker::Name.first_name
  password = "password123"

  User.create!(
    email: "#{first_name.downcase}.#{last_name.downcase}@example.com",
    password: password,
    password_confirmation: password,
    first_name: first_name,
    last_name: last_name,
    username: username
  )
end

Genre.create!(name: "Action & Adventure")
Genre.create!(name: "Animation")
Genre.create!(name: "Comedy")
Genre.create!(name: "Crime")
Genre.create!(name: "Documentary")
Genre.create!(name: "Drama")
Genre.create!(name: "Family")
Genre.create!(name: "Kids")
Genre.create!(name: "Mystery")
Genre.create!(name: "News")
Genre.create!(name: "Reality")
Genre.create!(name: "Sci-Fi & Fantasy")
Genre.create!(name: "Soap")
Genre.create!(name: "Talk")
Genre.create!(name: "War & Politics")
Genre.create!(name: "Western")
Genre.create!(name: "Action")
Genre.create!(name: "Adventure")
Genre.create!(name: "Fantasy")
Genre.create!(name: "History")
Genre.create!(name: "Horror")
Genre.create!(name: "Music")
Genre.create!(name: "Romance")
Genre.create!(name: "Science Fiction")
Genre.create!(name: "TV Movie")
Genre.create!(name: "Thriller")
Genre.create!(name: "War")


# db/seeds.rb

streaming_providers = [
{ name: "Netflix", api_id: 8, logo_path: "/pbpMk2JmcoNnQwx5JGpXngfoWtp.jpg" },
{ name: "Disney Plus", api_id: 337, logo_path: "/97yvRBw1GzX7fXprcF80er19ot.jpg" },
{ name: "Amazon Prime Video", api_id: 9, logo_path: "/qGXUKTheetVXYsSs9ehYLm7rzp8.jpg" },
{ name: "Apple TV", api_id: 2, logo_path: "/9ghgSC0MA082EL6HLCW3GalykFD.jpg" },
{ name: "Rakuten TV", api_id: 35, logo_path: "/bZvc9dXrXNly7cA0V4D9pR8yJwm.jpg" },
{ name: "Crunchyroll", api_id: 283, logo_path: "/mXeC4TrcgdU6ltE9bCBCEORwSQR.jpg" },
{ name: "Paramount Plus", api_id: 531, logo_path: "/h5DcR0J2EESLitnhR8xLG1QymTE.jpg" },
{ name: "Channel 4", api_id: 103, logo_path: "/uMWCgjsGnO5IoQtqxXOjnQA5gt9.jpg" },
{ name: "Sky Go", api_id: 29, logo_path: "/1UrT2H9x6DuQ9ytNhsSCUFtTUwS.jpg" },
{ name: "BBC iPlayer", api_id: 38, logo_path: "/nc8Tpsr8SqCbsTUogPDD06gGzB3.jpg" },
{ name: "MUBI", api_id: 11, logo_path: "/fj9Y8iIMFUC6952HwxbGixTQPb7.jpg" },
{ name: "Sky Store", api_id: 130, logo_path: "/6AKbY2ayaEuH4zKg2prqoVQ9iaY.jpg" },
{ name: "Freevee", api_id: 613, logo_path: "/4VOCKZGiAtXMtoDyOrvHAN33uc2.jpg" },
{ name: "ITVX", api_id: 41, logo_path: "/1LuvKw01c2KQCt6DqgAgR06H2pT.jpg" },
{ name: "YouTube Premium", api_id: 188, logo_path: "/rMb93u1tBeErSYLv79zSTR07UdO.jpg" },
{ name: "My5", api_id: 333, logo_path: "/5qLpN8ah2FZC8NpYFwRFwxlNjRn.jpg" },
{ name: "BritBox Amazon Channel", api_id: 197, logo_path: "/tLBLABfFYYETf9Zk8gKEWnjhMai.jpg" },
{ name: "Now TV", api_id: 39, logo_path: "/g0E9h3JAeIwmdvxlT73jiEuxdNj.jpg" },
{ name: "FilmBox+", api_id: 701, logo_path: "/fbveJTcro9Xw2KuPIIoPPePHiwy.jpg" },
{ name: "Discovery+", api_id: 524, logo_path: "/bPW3J8KlLrot95sLzadnpzVe61f.jpg" },
]

tmdb_base_url = "https://image.tmdb.org/t/p/original"


streaming_providers.each do |provider|

  watch_provider = WatchProvider.create(
    name: provider[:name],
    api_id: provider[:api_id]
  )


  logo_url = "#{tmdb_base_url}#{provider[:logo_path]}"
  downloaded_logo = URI.open(logo_url)


  watch_provider.logo.attach(
    io: downloaded_logo,
    filename: "#{provider[:name].parameterize}_logo.jpg",
    content_type: 'image/jpeg'
  )

  puts "Seeded #{provider[:name]} with logo."

end
