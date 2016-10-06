class AddOriginUrlToPages < ActiveRecord::Migration[5.0]
  def change
    add_column :pages, :origin_url, :string
  end
end
