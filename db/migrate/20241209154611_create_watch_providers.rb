class CreateWatchProviders < ActiveRecord::Migration[7.1]
  def change
    create_table :watch_providers do |t|
      t.string :name
      t.integer :api_id

      t.timestamps
    end
  end
end
