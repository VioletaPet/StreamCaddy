class CreateMediaWatchProviders < ActiveRecord::Migration[7.1]
  def change
    create_table :media_watch_providers do |t|
      t.references :watch_provider, null: false, foreign_key: true
      t.references :media, null: false, foreign_key: true

      t.timestamps
    end
  end
end
