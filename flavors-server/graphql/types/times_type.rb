module Types
  class TimesType < GraphQL::Schema::Object
    field :preparation, String, null: false
    field :cooking, String, null: false
  end
end
