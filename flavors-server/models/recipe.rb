class Recipe < ActiveRecord::Base
  has_many :ingredients, dependent: :destroy
  has_many :steps, dependent: :destroy
  has_one :times, dependent: :destroy
end
