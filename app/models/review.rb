class Review < ApplicationRecord
  belongs_to :media
  belongs_to :user

  validates :content, presence: true
  validates :rating, presence: true, inclusion: { in: (1..5).to_a }
end
