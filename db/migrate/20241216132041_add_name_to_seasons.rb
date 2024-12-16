class AddNameToSeasons < ActiveRecord::Migration[7.1]
  def change
    add_column :seasons, :name, :string
  end
end
