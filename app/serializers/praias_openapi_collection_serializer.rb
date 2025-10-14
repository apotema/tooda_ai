class PraiasOpenapiCollectionSerializer < ActiveModel::Serializer
  attributes :praias, :pagination

  def praias
    ActiveModelSerializers::SerializableResource.new(
      object[:praias],
      each_serializer: PraiaOpenapiSerializer
    ).as_json
  end

  def pagination
    PaginationSerializer.new(object[:praias]).as_json
  end
end
