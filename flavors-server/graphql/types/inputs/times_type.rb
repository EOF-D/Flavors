module Types::Inputs
  # TODO: Implement this later when time is properly serialized.
  class TimeInputType < GraphQL::Schema::InputObject
    argument :min, Int, required: false, description: "Minimum time in minutes"
    argument :max, Int, required: false, description: "Maximum time in minutes"
  end
end
