class User < ApplicationRecord
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

  

end
