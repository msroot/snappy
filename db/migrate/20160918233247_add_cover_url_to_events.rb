class AddCoverUrlToEvents < ActiveRecord::Migration[5.0]
  def change
    add_column :events, :cover_url, :text
  end
end
