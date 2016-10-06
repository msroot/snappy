class RemoveCountToPages < ActiveRecord::Migration[5.0]
  def change
      remove_column :pages, :events_count
      remove_column :places, :events_count
  end
end
