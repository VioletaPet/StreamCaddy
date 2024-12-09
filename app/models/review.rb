class Review < ApplicationRecord
  belongs_to :media
  belongs_to :user

  validates :content, presence: true
end
