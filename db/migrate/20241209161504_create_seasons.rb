class CreateSeasons < ActiveRecord::Migration[7.1]
  def change
    create_table :seasons do |t|
      t.references :media, null: false, foreign_key: true
      t.integer :number
      t.integer :episodes
      t.text :synopsis

      t.timestamps
    end
  end
end
