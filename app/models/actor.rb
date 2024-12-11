class Actor < ApplicationRecord
  has_many :media_actors
  has_many :medias, through: :media_actors
  has_many_attached :photos
end
