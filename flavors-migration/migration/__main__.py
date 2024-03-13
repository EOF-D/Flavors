from __future__ import annotations

from json import dumps, loads
from os.path import abspath, dirname
from typing import TypedDict

from ingredient_parser import parse_ingredient
from ingredient_parser.postprocess import CompositeIngredientAmount

PATH = (
    dirname(dirname(abspath(__file__))) + "/../flavors-server/assets/raw/recipes.json"
)


class Time(TypedDict):
    Prepation: str
    Cooking: str


class ParsedIngredient(TypedDict):
    name: str
    quantity: str
    unit: str
    preparation: str


class Recipe(TypedDict):
    id: str
    url: str

    name: str
    author: str
    rattings: str

    description: str
    ingredients: list[str]
    steps: list[str]

    times: Time
    difficult: str
    serves: int


class ParsedRecipe(TypedDict):
    id: str
    url: str

    name: str
    author: str
    ratings: str

    description: str
    ingredients: list[ParsedIngredient]
    steps: list[str]

    times: Time
    serves: int
    difficult: str


def parse(recipe: Recipe) -> ParsedRecipe:
    final_ingredients: list[ParsedIngredient] = []

    for ingredient in recipe["ingredients"]:
        parsed = parse_ingredient(ingredient)

        for quantity in parsed.amount:
            if isinstance(quantity, CompositeIngredientAmount):
                continue

            name = getattr(parsed.name, "text", parsed.sentence)
            prep = getattr(parsed.preparation, "text", "")

            final_ingredients.append(
                {
                    "name": name,
                    "quantity": quantity.quantity,
                    "unit": quantity.unit,
                    "preparation": prep,
                }
            )

    return {
        "id": recipe["id"],
        "url": recipe["url"],
        "name": recipe["name"],
        "author": recipe["author"],
        "ratings": recipe["rattings"],
        "description": recipe["description"],
        "ingredients": final_ingredients,
        "steps": recipe["steps"],
        "times": recipe["times"],
        "serves": recipe["serves"],
        "difficult": recipe["difficult"],
    }


def format() -> None:
    formatted: list[ParsedRecipe] = []

    with open(PATH, "r") as file:
        recipes = loads(file.read())

        for recipe in recipes:
            formatted.append(parse(recipe))

    with open(PATH, "w") as file:
        file.write(dumps(formatted, indent=4))


if __name__ == "__main__":
    ui = input("Commands: (1)format, 2(exit): ")

    if ui.lower() == "1":
        format()
        print("Format complete")

    elif ui.lower() == "2":
        exit()
