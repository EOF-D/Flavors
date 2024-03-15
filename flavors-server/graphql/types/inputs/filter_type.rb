module Types::Inputs
  class FilterType < GraphQL::Schema::InputObject
    argument :name, String, required: false, description: "Filter by recipe name (fuzzy and case-insensitive)"
    argument :ingredients, [String], required: false, description: "Filter by ingredients (fuzzy and case-insensitive)"
  end
end
