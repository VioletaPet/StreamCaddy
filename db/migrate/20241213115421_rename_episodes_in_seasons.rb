class RenameEpisodesInSeasons < ActiveRecord::Migration[7.1]
  def change
    rename_column :seasons, :episodes, :no_of_episodes
  end
end
