class AddCountToPages < ActiveRecord::Migration[5.0]
  def change
    add_column :pages, :events_count, :integer, default: 0
    add_column :places, :events_count, :integer, default: 0
  end
end
