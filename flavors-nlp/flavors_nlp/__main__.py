from __future__ import annotations

from argparse import ArgumentParser

from flavors_nlp import (
    __version__,
    __author__, 
    __license__
)

def gen_parser() -> ArgumentParser:
    parser = ArgumentParser(
        description="Flavors-NLP interface",
        prog="Flavors-NLP"
    )

    parser.add_argument("--version", action="store_true")
    parser.add_argument("--author", action="store_true")

    return parser

def main() -> None:
    parser: ArgumentParser = gen_parser()
    args = parser.parse_args()

    if args.version is True:
        print(f"Version: {__version__}\nLicense: {__license__}")

    elif args.author is True:
        print(f"Author {__author__}")

    return None;

if __name__ == "__main__":
    main()
