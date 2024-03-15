class CreateTimes < ActiveRecord::Migration[7.1]
  def change
    create_table :times do |t|
      t.uuid :recipe_id, null: false
      t.text :preparation_time
      t.text :cooking_time
      t.timestamps
    end

    add_foreign_key :times, :recipes, column: :recipe_id
  end
end
