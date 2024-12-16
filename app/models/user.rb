class User < ApplicationRecord
  has_one_attached :avatar
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :user_providers
  has_many :watch_providers, through: :user_providers
  has_many :watchlist_media
  has_many :medias, through: :watchlist_media
  has_many :media_genres, through: :medias
  has_many :genres, through: :media_genres
  has_many :seasons, through: :medias
  has_many :episodes, through: :seasons
  validates :first_name, :last_name, presence: true
  validates :email, :username, uniqueness: true

  def calculate_genre_percentages(user_genres)
    genre_count = user_genres.each_with_object(Hash.new(0)) do |genre, count|
      counts[genre.name] += 1
    end
  end

  def avatar_url
    avatar.attached? ? avatar : 'https://www.hartz.com/wp-content/uploads/2022/04/small-dog-owners-1.jpg'
  end
end
