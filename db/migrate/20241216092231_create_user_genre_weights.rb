class CreateUserGenreWeights < ActiveRecord::Migration[7.1]
  def change
    create_table :user_genre_weights do |t|
      t.references :user, null: false, foreign_key: true
      t.references :genre, null: false, foreign_key: true
      t.float :weight

      t.timestamps
    end
  end
end
