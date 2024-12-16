class WatchlistMedium < ApplicationRecord
  belongs_to :user
  belongs_to :media
  has_many :reviews, dependent: :destroy

  validates :user_id, uniqueness: { scope: :media_id }
end
