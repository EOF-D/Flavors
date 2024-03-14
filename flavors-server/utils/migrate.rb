require "json"
require "pg"

conn = PG.connect(dbname: "flavors-db")
recipes = JSON.parse(File.read(__dir__ + "/../assets/raw/recipes.json"))

# Insert recipes into the database
recipes.each do |recipe|
  conn.exec_params(
    "INSERT INTO recipes (id, url, name, author, ratings, description, serves, difficulty) VALUES ($1, $2, $3, $4, $5, $6, $7, $8)",
    [recipe["id"], recipe["url"], recipe["name"], recipe["author"], recipe["ratings"], recipe["description"],
      recipe["serves"], recipe["difficult"]]
  )

  recipe["ingredients"].each_with_index do |ingredient, _index|
    conn.exec_params(
      "INSERT INTO ingredients (recipe_id, name, quantity, unit, preparation) VALUES ($1, $2, $3, $4, $5)",
      [recipe["id"], ingredient["name"], ingredient["quantity"], ingredient["unit"], ingredient["preparation"]]
    )
  end

  recipe["steps"].each_with_index do |step_text, index|
    conn.exec_params(
      "INSERT INTO steps (recipe_id, step_number, step_text) VALUES ($1, $2, $3)",
      [recipe["id"], index + 1, step_text]
    )
  end

  conn.exec_params(
    "INSERT INTO times (recipe_id, preparation_time, cooking_time) VALUES ($1, $2, $3)",
    [recipe["id"], recipe["times"]["Preparation"], recipe["times"]["Cooking"]]
  )
end

# Close the database connection
conn.close
