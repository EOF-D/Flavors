from __future__ import annotations

from json import dumps, loads
from typing import NamedTuple

from ingredient_parser import parse_ingredient
from ingredient_parser.postprocess import CompositeIngredientAmount


class Ingredient(NamedTuple):
    name: str
    quantity: str
    unit: str
    preparations: str


class Recipe(NamedTuple):
    id: str
    author: str
    name: str
    description: str
    instructions: list[str]
    ingredients: list[Ingredient]


def parse(recipe: dict) -> Recipe:
    ingredients: list[Ingredient] = []

    for raw_str in recipe["ingredients"]:
        extracted = parse_ingredient(raw_str)

        for quantity in extracted.amount:
            if isinstance(quantity, CompositeIngredientAmount):
                continue

            name = getattr(extracted.name, "text", None) or extracted.sentence
            preparation = getattr(extracted.preparation, "text", None) or ""

            ingredients.append(
                Ingredient(
                    name,
                    quantity.quantity,
                    quantity.unit,
                    preparation,
                )
            )

    return Recipe(
        recipe["id"],
        recipe["author"],
        recipe["name"],
        recipe["description"],
        recipe["steps"],
        ingredients,
    )


def migrate() -> list[Recipe]:
    database: list[Recipe] = []

    with open("../assets/recipes.json", "r") as file:
        for recipe in loads(file.read()):
            database.append(parse(recipe))

    return database


if __name__ == "__main__":
    with open("../assets/test.json", "w") as fp:
        fp.write(dumps([recipe._asdict() for recipe in migrate()], indent=2))
