module Types::Inputs
  class UserRecipeType < GraphQL::Schema::InputObject
    argument :id, ID, required: true, description: 'Add recipe by ID.'
  end
end
