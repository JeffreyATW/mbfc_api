class Bias < ApplicationRecord
  has_many :sources

  validates :slug, uniqueness: true
end
