class WatchlistMedium < ApplicationRecord
  belongs_to :user
  belongs_to :media

  validates :user_id, uniqueness: { scope: :media_id }
end
