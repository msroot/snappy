class AddStateToLocation < ActiveRecord::Migration[5.0]
  def change
    add_column :locations, :state, :string
  end
end
