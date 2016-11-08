class Source < ApplicationRecord
  belongs_to :bias

  validates :domain, uniqueness: true
end
