class SourceSerializer < ActiveModel::Serializer
  attributes :name, :notes, :homepage, :domain, :url
  belongs_to :bias
end
