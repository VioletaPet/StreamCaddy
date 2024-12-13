class AddApiIdToGenres < ActiveRecord::Migration[7.1]
  def change
    add_column :genres, :api_id, :string
  end
end
