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
  { name: "Netflix", api_id: 8 },
  { name: "Disney Plus", api_id: 337 },
  { name: "Amazon Prime Video", api_id: 9 },
  { name: "Apple TV Plus", api_id: 350 },
  { name: "Apple TV", api_id: 2 },
  { name: "Rakuten TV", api_id: 35 },
  { name: "Crunchyroll", api_id: 283 },
  { name: "Amazon Video", api_id: 10 },
  { name: "Paramount Plus", api_id: 531 },
  { name: "Channel 4", api_id: 103 },
  { name: "Sky Go", api_id: 29 },
  { name: "Crunchyroll Amazon Channel", api_id: 1968 },
  { name: "BBC iPlayer", api_id: 38 },
  { name: "MUBI", api_id: 11 },
  { name: "Google Play Movies", api_id: 3 },
  { name: "BFI Player", api_id: 224 },
  { name: "Sky Store", api_id: 130 },
  { name: "Microsoft Store", api_id: 68 },
  { name: "Freevee", api_id: 613 },
  { name: "Curzon Home Cinema", api_id: 189 },
  { name: "ITVX", api_id: 41 },
  { name: "YouTube", api_id: 192 },
  { name: "Shudder", api_id: 99 },
  { name: "ARROW", api_id: 529 },
  { name: "Arrow Video Amazon Channel", api_id: 596 },
  { name: "GuideDoc", api_id: 100 },
  { name: "Netflix Kids", api_id: 175 },
  { name: "YouTube Premium", api_id: 188 },
  { name: "BFI Player Amazon Channel", api_id: 287 },
  { name: "My5", api_id: 333 },
  { name: "BritBox Amazon Channel", api_id: 197 },
  { name: "MUBI Amazon Channel", api_id: 201 },
  { name: "STUDIOCANAL PRESENTS Apple TV Channel", api_id: 642 },
  { name: "STV Player", api_id: 593 },
  { name: "Curiosity Stream", api_id: 190 },
  { name: "Flix Premiere", api_id: 432 },
  { name: "Revry", api_id: 473 },
  { name: "DOCSVILLE", api_id: 475 },
  { name: "Now TV", api_id: 39 },
  { name: "Spamflix", api_id: 521 },
  { name: "JustWatchTV", api_id: 2285 },
  { name: "Plex", api_id: 538 },
  { name: "WOW Presents Plus", api_id: 546 },
  { name: "Magellan TV", api_id: 551 },
  { name: "BroadwayHD", api_id: 554 },
  { name: "Filmzie", api_id: 559 },
  { name: "Acorn TV", api_id: 87 },
  { name: "AcornTV Amazon Channel", api_id: 196 },
  { name: "Dekkoo", api_id: 444 },
  { name: "True Story", api_id: 567 },
  { name: "DocAlliance Films", api_id: 569 },
  { name: "Hoichoi", api_id: 315 },
  { name: "Now TV Cinema", api_id: 591 },
  { name: "CuriosityStream Amazon Channel", api_id: 603 },
  { name: "DocuBay Amazon Channel", api_id: 604 },
  { name: "Discovery+ Amazon Channel", api_id: 584 },
  { name: "Fandor Amazon Channel", api_id: 199 },
  { name: "Full Moon Amazon Channel", api_id: 597 },
  { name: "Pokémon Amazon Channel", api_id: 599 },
  { name: "Shout! Factory Amazon Channel", api_id: 600 },
  { name: "Shudder Amazon Channel", api_id: 204 },
  { name: "Eros Now Amazon Channel", api_id: 595 },
  { name: "FilmBox Live Amazon Channel", api_id: 602 },
  { name: "W4free", api_id: 615 },
  { name: "Pluto TV", api_id: 300 },
  { name: "Eventive", api_id: 677 },
  { name: "ShortsTV Amazon Channel", api_id: 688 },
  { name: "Cultpix", api_id: 692 },
  { name: "FilmBox+", api_id: 701 },
  { name: "Paramount+ Amazon Channel", api_id: 582 },
  { name: "Discovery+", api_id: 524 },
  { name: "Curzon Amazon Channel", api_id: 1745 },
  { name: "Icon Film Amazon Channel", api_id: 1744 },
  { name: "Hallmark TV Amazon Channel", api_id: 1746 },
  { name: "Studiocanal Presents Amazon Channel", api_id: 1747 },
  { name: "Sundance Now Amazon Channel", api_id: 205 },
  { name: "Sooner Amazon Channel", api_id: 1757 },
  { name: "Takflix", api_id: 1771 },
  { name: "Klassiki", api_id: 1793 },
  { name: "Sun Nxt", api_id: 309 },
  { name: "Viaplay", api_id: 76 },
  { name: "Netflix basic with Ads", api_id: 1796 },
  { name: "Paramount Plus Apple TV Channel ", api_id: 1853 },
  { name: "Runtime", api_id: 1875 },
  { name: "OUTtv Amazon Channel", api_id: 607 },
  { name: "Shahid VIP", api_id: 1715 },
  { name: "Acorn TV Apple TV", api_id: 2034 },
  { name: "CuriosityStream Apple TV Channel", api_id: 2060 },
  { name: "BFI Player Apple TV Channel", api_id: 2041 },
  { name: "Kocowa", api_id: 464 },
  { name: "Amazon Prime Video with Ads", api_id: 2100 },
  { name: "Arte", api_id: 234 },
  { name: "MGM Plus Amazon Channel", api_id: 2141 },
  { name: "Okidoki Amazon Channel", api_id: 2264 },
  { name: "Stingray Classica Amazon Channel", api_id: 2273 },
  { name: "Stingray Djazz Amazon Channel", api_id: 2274 },
  { name: "Stingray Karaoke Amazon Channel", api_id: 2275 },
  { name: "TV1000 Russian Kino Amazon Channel", api_id: 2278 },
  { name: "ITVX Premium", api_id: 2300 },
  { name: "Apple TV Plus Amazon Channel", api_id: 2243 },
  { name: "Paramount Plus Premium", api_id: 2303 },
  { name: "Paramount Plus Basic with Ads", api_id: 2304 }
]

# Loop through each provider and seed the database (e.g., create a record in the database)
streaming_providers.each do |provider|
  WatchProvider.create(provider)
end

puts "Created #{WatchProvider.count} watch providers, #{Genre.count} genres, and #{User.count} users"
