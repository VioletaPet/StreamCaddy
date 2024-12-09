class Genre < ApplicationRecord
  has_many :media_genres
  has_many :medias, through: :media_genres
end
