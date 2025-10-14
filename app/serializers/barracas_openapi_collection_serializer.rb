class BarracasOpenapiCollectionSerializer < ActiveModel::Serializer
  attributes :barracas, :included, :pagination

  def barracas
    ActiveModelSerializers::SerializableResource.new(
      object[:barracas],
      each_serializer: BarracaOpenapiSerializer
    ).as_json
  end

  def included
    collection = object[:barracas]
    included_data = {
      praias: [],
      status_barracas: [],
      tipo_barracas: [],
      tipo_area_coberturas: []
    }

    # Collect unique related records
    praias = collection.map(&:praia).compact.uniq
    status_barracas = collection.map(&:status_barraca).compact.uniq
    tipo_barracas = collection.map(&:tipo_barraca).compact.uniq
    tipo_area_coberturas = collection.map(&:tipo_area_cobertura).compact.uniq

    # Serialize each type
    included_data[:praias] = praias.map do |praia|
      PraiaOpenapiSerializer.new(praia).as_json
    end

    included_data[:status_barracas] = status_barracas.map do |status|
      {
        id: status.Id,
        status: status.Status,
        status_en: LlmTranslator.translation(:barracas, :status).output(status.Id)
      }
    end

    included_data[:tipo_barracas] = tipo_barracas.map do |type|
      {
        id: type.Id,
        name: type.Nome
      }
    end

    included_data[:tipo_area_coberturas] = tipo_area_coberturas.map do |coverage|
      {
        id: coverage.Id,
        name: coverage.Nome
      }
    end

    included_data
  end

  def pagination
    PaginationSerializer.new(object[:barracas]).as_json
  end
end
