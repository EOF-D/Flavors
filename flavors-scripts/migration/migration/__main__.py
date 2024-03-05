from __future__ import annotations

import sys
from json import dumps, loads
from typing import TYPE_CHECKING, List, NamedTuple, TypedDict

# pyright: reportMissingTypeStubs=false
from ingredient_parser import parse_ingredient

if TYPE_CHECKING:
    from ingredient_parser.postprocess import CompositeIngredientAmount

PATH: str = "../../../flavors-server"


# TODO: Refactor this file to be better.
class Ingredient(NamedTuple):
    name: str
    quantity: str
    unit: str
    preparations: str


class Recipe(TypedDict):
    id: str
    author: str
    name: str
    description: str
    steps: list[str]
    instructions: list[str]
    ingredients: list[str]


class ParsedRecipe(TypedDict):
    id: str
    author: str
    name: str
    description: str
    instructions: list[str]
    ingredients: list[Ingredient] | list[str]


def parse(recipe: Recipe, nlp: bool) -> ParsedRecipe:
    ingredients: List[Ingredient] = []

    for raw_str in recipe["ingredients"]:
        if not nlp:
            continue

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

    instructions: list[str] = []
    for step in recipe["steps" if nlp else "instructions"]:
        instructions.append(step)

    return ParsedRecipe(
        id=recipe["id"],
        author=recipe["author"],
        name=recipe["name"],
        description=recipe["description"],
        instructions=recipe["steps"] if nlp else recipe["instructions"],
        ingredients=ingredients if nlp else recipe["ingredients"],
    )


def migrate(nlp: bool) -> List[ParsedRecipe]:
    database: List[ParsedRecipe] = []

    with open(f"{PATH}/assets/recipes.json", "r") as file:
        for recipe in loads(file.read()):
            database.append(parse(recipe, nlp))

    return database


if __name__ == "__main__":
    nlp: bool = len(sys.argv) > 1 and sys.argv[1] == "nlp"

    with open(f"{PATH}/assets/recipes.json", "w") as file:
        file.write(dumps([recipe._asdict() for recipe in migrate(nlp)], indent=2))  # type: ignore
