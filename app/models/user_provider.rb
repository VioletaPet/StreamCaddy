class UserProvider < ApplicationRecord
  belongs_to :watch_provider
  belongs_to :user
end
