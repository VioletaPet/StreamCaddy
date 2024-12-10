class RenameColumnsInUserProviders < ActiveRecord::Migration[7.1]
  def change
    rename_column :user_providers, :watch_providers_id, :watch_provider_id
    rename_column :user_providers, :users_id, :user_id
  end
end
