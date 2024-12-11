class AddCharacterToMediaActors < ActiveRecord::Migration[7.1]
  def change
    add_column :media_actors, :character, :string
  end
end
