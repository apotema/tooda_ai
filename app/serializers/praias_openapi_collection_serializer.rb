class PraiasOpenapiCollectionSerializer < ActiveModel::Serializer
  attributes :praias, :included, :pagination

  def praias
    ActiveModelSerializers::SerializableResource.new(
      object[:praias],
      each_serializer: PraiaOpenapiSerializer
    ).as_json
  end

  def included
    # Praias don't have relationships to include,
    # but we keep the empty structure for JSON:API-inspired consistency
    {}
  end

  def pagination
    PaginationSerializer.new(object[:praias]).as_json
  end
end
