class AddFlatrateBuyRentToMediaWatchProviders < ActiveRecord::Migration[7.1]
  def change
    add_column :media_watch_providers, :flatrate, :boolean
    add_column :media_watch_providers, :buy, :boolean
    add_column :media_watch_providers, :rent, :boolean
  end
end
