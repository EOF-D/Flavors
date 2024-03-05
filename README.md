Flavors
=======
A frontend & backend recipe database.

features
--------
  - Fuzzy searching via ingredients.
  - Graphical UI via Qt.
  - GraphQl Database.

TODOs
-----
  - ( ) Flavors-server
    -- (x) Ingredients NLP (Python)
    -- ( ) Server interface (Haskell)
    -- ( ) JSON database
    -- ( ) Database migration with Ingredients NLP

  - ( ) Flavors-Client
    -- ( ) Non-graphical client
    -- ( ) Implement Graphical UI

Libraries/Packages used & Documentation.
----------------------------------------
  - [Ingredient NLP](https://github.com/strangetom/ingredient-parser)
  - [Morpheus-GraphQL](https://github.com/morpheusgraphql/morpheus-graphql)
  - [Qt](https://www.qt.io/)


Diagram:
```
┌─────────────────┐
│    flavors      │                 
└───────────┬─────┘
            │
       ┌────┴───────┐
       │ Build Files│
       │ (CMake,    │
       │ Cabal,     │
       │ Stack,     │
       │ Nix)       │
       └────┬───────┘
            │
   ┌────────┴───────┐
   │                │
┌──┴───┐       ┌────┴─────┐
│client│       │  server  │
└───┬──┘       └────┬─────┘
    │               │
    │               │
┌───┴──────────┐    │    ┌───────────┐
│C++ Frontend  │    │    │ Haskell   │
│ (Qt library) │    ├────│  Backend  │
└──────────────┘    │    └───────────┘
                    │
      ┌─────────────┘
      │
 ┌────┴───────┐
 │Python-based│
 │  Migration │
 └────┬───────┘
      │
      │
┌─────┴─────────────────┐
│Database (recipes.json)│
└───────────────────────┘
```
