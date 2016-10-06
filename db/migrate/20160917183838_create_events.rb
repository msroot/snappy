class CreateEvents < ActiveRecord::Migration[5.0]
  def change
    create_table :events do |t|
      t.text :description
      t.string :name
      t.datetime :start_time
      t.datetime :end_time
      t.references :page, foreign_key: true
      t.references :place, foreign_key: true
      t.string :fb_id

      t.timestamps
    end
  end
end
