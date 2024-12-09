class WatchProvider < ApplicationRecord
  has_many :users, through: :user_providers
  has_many :medias, through: :media_watch_providers
end
