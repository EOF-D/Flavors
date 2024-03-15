class CreateSteps < ActiveRecord::Migration[7.1]
  def change
    create_table :steps, id: :serial do |t|
      t.uuid :recipe_id, null: false
      t.integer :step_number, null: false
      t.text :step_text, null: false
      t.timestamps
    end

    add_foreign_key :steps, :recipes
  end
end
