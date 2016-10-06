class CreateLocations < ActiveRecord::Migration[5.0]
  def change
    create_table :locations do |t|
      t.string :city
      t.string :country
      t.decimal :latitude, :precision=>10, :scale=>6
      t.decimal :longitude, :precision=>10, :scale=>6
      t.string :street
      t.string :zip

      t.timestamps
    end
  end
end
