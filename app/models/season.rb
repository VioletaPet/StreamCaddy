class Season < ApplicationRecord
  belongs_to :media
  has_many :episodes
end
