class CreateRecipes < ActiveRecord::Migration[7.1]
  def change
    create_table :recipes, id: :uuid do |t|
      t.text :url
      t.text :name, null: false
      t.text :author
      t.integer :ratings
      t.text :description
      t.integer :serves
      t.text :difficulty
      t.timestamps
    end
  end
end
