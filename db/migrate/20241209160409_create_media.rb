class CreateMedia < ActiveRecord::Migration[7.1]
  def change
    create_table :media do |t|
      t.string :title
      t.string :type
      t.text :synopsis
      t.string :creator
      t.integer :api_id
      t.date :release_date
      t.string :run_time

      t.timestamps
    end
  end
end
