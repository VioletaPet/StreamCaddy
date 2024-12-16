class Review < ApplicationRecord
  belongs_to :media
  belongs_to :user
  belongs_to :watchlist_medium

  validates :content, presence: true
  validates :rating, presence: true, inclusion: { in: [1..5] }
end
