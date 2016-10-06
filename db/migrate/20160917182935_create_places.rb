class CreatePlaces < ActiveRecord::Migration[5.0]
  def change
    create_table :places do |t|
      t.string :name
      t.references :location, foreign_key: true
      t.string :fb_id

      t.timestamps
    end
  end
end
