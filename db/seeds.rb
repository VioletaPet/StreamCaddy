# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
User.destroy_all
Genre.destroy_all
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
