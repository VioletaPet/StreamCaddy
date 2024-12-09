class CreateUserProviders < ActiveRecord::Migration[7.1]
  def change
    create_table :user_providers do |t|
      t.references :watch_providers, null: false, foreign_key: true
      t.references :users, null: false, foreign_key: true

      t.timestamps
    end
  end
end
