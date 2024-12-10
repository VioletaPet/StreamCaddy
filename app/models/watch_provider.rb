class WatchProvider < ApplicationRecord
  has_many :user_providers
  has_many :media_watch_providers
  has_many :users, through: :user_providers
  has_many :medias, through: :media_watch_providers
end
