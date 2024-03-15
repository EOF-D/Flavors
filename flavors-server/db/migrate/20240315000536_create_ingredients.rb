class CreateIngredients < ActiveRecord::Migration[7.1]
  def change
    create_table :ingredients, id: :serial do |t|
      t.uuid :recipe_id, null: false
      t.text :name, null: false
      t.text :quantity
      t.text :unit
      t.text :preparation
      t.timestamps
    end

    add_foreign_key :ingredients, :recipes
  end
end
