class RenameTypeToNameInGenre < ActiveRecord::Migration[7.1]
  def change
    rename_column :genres, :type, :name
  end
end
