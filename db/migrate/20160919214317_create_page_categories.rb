class CreatePageCategories < ActiveRecord::Migration[5.0]
  def change
    create_table :page_categories do |t|
      t.integer :category_id
      t.integer :page_id
    end
    
        add_index :page_categories, [:page_id, :category_id]  
        add_index :page_categories, [:category_id, :page_id]  
        
  end
end
