CREATE TABLE recipes (
    id UUID PRIMARY KEY,
    url TEXT,
    name TEXT NOT NULL,
    author TEXT,
    ratings INT,
    description TEXT,
    serves INT,
    difficulty TEXT
);

CREATE TABLE ingredients (
    id SERIAL PRIMARY KEY,
    recipe_id UUID NOT NULL REFERENCES recipes(id),
    name TEXT NOT NULL,
    quantity TEXT,
    unit TEXT,
    preparation TEXT
);

CREATE TABLE steps (
    id SERIAL PRIMARY KEY,
    recipe_id UUID NOT NULL REFERENCES recipes(id),
    step_number INT NOT NULL,
    step_text TEXT NOT NULL
);

CREATE TABLE times (
    id SERIAL PRIMARY KEY,
    recipe_id UUID NOT NULL REFERENCES recipes(id),
    preparation_time TEXT,
    cooking_time TEXT
);
