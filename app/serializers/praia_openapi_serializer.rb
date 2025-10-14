class PraiaOpenapiSerializer < ActiveModel::Serializer
  # LLM-friendly attributes (English names)
  attributes :id, :name, :city, :state

  # Delegate database attributes to object
  delegate :Id, :Nome, :Cidade, :Uf, to: :object

  # Attribute mappings using alias
  alias id Id
  alias name Nome
  alias city Cidade
  alias state Uf
end
