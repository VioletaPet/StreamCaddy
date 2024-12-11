class AddApiIdToActors < ActiveRecord::Migration[7.1]
  def change
    add_column :actors, :api_id, :integer
    add_index :actors, :api_id, unique: true
  end
end
