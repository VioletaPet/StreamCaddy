class CreateMediaActors < ActiveRecord::Migration[7.1]
  def change
    create_table :media_actors do |t|
      t.references :actor, null: false, foreign_key: true
      t.references :media, null: false, foreign_key: true

      t.timestamps
    end
  end
end
