class BiasSerializer < ActiveModel::Serializer
  attributes :name, :description, :slug, :url
  has_many :sources
end
