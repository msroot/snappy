class AddXAndYToPages < ActiveRecord::Migration[5.0]
  def change
    add_column :events, :cover_offset_y, :integer, default: 0
    add_column :events, :cover_offset_x, :integer, default: 0
  end
end
