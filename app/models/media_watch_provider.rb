class MediaWatchProvider < ApplicationRecord
  belongs_to :watch_provider
  belongs_to :media
end
