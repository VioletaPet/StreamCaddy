class MediaGenre < ApplicationRecord
  belongs_to :media
  belongs_to :genre
end
