class RecipeTime < ActiveRecord::Base
  belongs_to :recipe
  before_validation :set_default_values

  private

  def set_default_values
    self.preparation = 'No Time' if preparation.blank?
    self.cooking = 'No Time' if cooking.blank?
  end
end
