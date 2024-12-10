class RenameTypeToCategoryInMedia < ActiveRecord::Migration[7.1]
  def change
    rename_column :media, :type, :category
  end
end
