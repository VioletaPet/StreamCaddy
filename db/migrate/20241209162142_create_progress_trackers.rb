class CreateProgressTrackers < ActiveRecord::Migration[7.1]
  def change
    create_table :progress_trackers do |t|
      t.references :user, null: false, foreign_key: true
      t.boolean :watched

      t.timestamps
    end
  end
end
