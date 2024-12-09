class AddAverageRatingToMedia < ActiveRecord::Migration[7.1]
  def change
    add_column :media, :average_rating, :float
  end
end
