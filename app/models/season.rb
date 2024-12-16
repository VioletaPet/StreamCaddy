class Season < ApplicationRecord
  belongs_to :media
  has_many :episodes
  has_one_attached :poster
  # validates :media, uniqueness: { scope: :number }
end
