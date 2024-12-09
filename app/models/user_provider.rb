class UserProvider < ApplicationRecord
  belongs_to :watch_providers
  belongs_to :users
end
