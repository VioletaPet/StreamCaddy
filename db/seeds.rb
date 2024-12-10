# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
User.destroy
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
