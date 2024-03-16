class CreateRecipeTimes < ActiveRecord::Migration[7.1]
  def change
    create_table :recipe_times do |t|
      t.uuid :recipe_id, null: false
      t.text :preparation
      t.text :cooking
      t.timestamps
    end

    add_foreign_key :recipe_times, :recipes, column: :recipe_id
  end
end
