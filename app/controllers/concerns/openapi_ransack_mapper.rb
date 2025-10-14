module OpenapiRansackMapper
  extend ActiveSupport::Concern
  include LlmTranslator

  # Map clean English param names to Ransack predicates
  # Format: { english_param: { attribute: 'ModelAttribute', predicate: 'ransack_predicate' } }

  BARRACA_PARAM_MAP = {
    # String fields - use 'cont' (contains) for text search
    'name' => { attribute: 'Nome', predicate: 'cont' },
    'number' => { attribute: 'Numero', predicate: 'cont' },
    'license' => { attribute: 'Licenca', predicate: 'cont' },
    'cpf_cnpj' => { attribute: 'CpfCnpj', predicate: 'cont' },
    'pix_key' => { attribute: 'ChavePix', predicate: 'cont' },

    # Numeric/ID fields - use 'eq' (equals)
    'id' => { attribute: 'Id', predicate: 'eq' },
    'beach_id' => { attribute: 'PraiaId', predicate: 'eq' },
    'status_id' => { attribute: 'StatusBarracaId', predicate: 'eq' },
    'status' => {
      attribute: 'StatusBarracaId',
      predicate: 'eq',
      translate: { resource: :barracas, field: :status }
    },
    'type_id' => { attribute: 'TipoBarracaId', predicate: 'eq' },
    'coverage_type_id' => { attribute: 'TipoAreaCoberturaId', predicate: 'eq' },

    # Decimal fields - use 'eq' for exact match
    'commission_percentage' => { attribute: 'PercentualComissao', predicate: 'eq' },
    'card_commission_percentage' => { attribute: 'PercentualComissaoCartao', predicate: 'eq' },
    'delivery_fee' => { attribute: 'TaxaEntrega', predicate: 'eq' },
    'service_fee' => { attribute: 'TaxaServico', predicate: 'eq' },

    # Location fields
    'latitude' => { attribute: 'Latitude', predicate: 'eq' },
    'longitude' => { attribute: 'Longitude', predicate: 'eq' },
    'delivery_radius' => { attribute: 'RaioEntrega', predicate: 'eq' },

    # Date fields - use 'gteq' and 'lteq' for ranges
    'created_after' => { attribute: 'DataInclusao', predicate: 'gteq' },
    'created_before' => { attribute: 'DataInclusao', predicate: 'lteq' }
  }.freeze

  PRAIA_PARAM_MAP = {
    'id' => { attribute: 'Id', predicate: 'eq' },
    'name' => { attribute: 'Nome', predicate: 'cont' },
    'city' => { attribute: 'Cidade', predicate: 'cont' },
    'state' => { attribute: 'Uf', predicate: 'eq' }
  }.freeze

  # Sorting parameter mapping
  BARRACA_SORT_MAP = {
    'name' => 'Nome',
    'number' => 'Numero',
    'created_at' => 'DataInclusao',
    'commission' => 'PercentualComissao'
  }.freeze

  PRAIA_SORT_MAP = {
    'name' => 'Nome',
    'city' => 'Cidade',
    'state' => 'Uf'
  }.freeze

  private

  def build_ransack_params(param_map, sort_map)
    ransack_params = {}

    # Map search parameters
    param_map.each do |english_param, config|
      value = params[english_param]
      next if value.blank?

      # Translate value if needed using generic translator
      # e.g., status: "open" → 4
      if config[:translate]
        resource = config[:translate][:resource]
        field = config[:translate][:field]
        value = LlmTranslator.translation(resource, field).input(value)
        next if value.nil? # Skip if translation failed
      end

      ransack_key = "#{config[:attribute]}_#{config[:predicate]}"
      ransack_params[ransack_key] = value
    end

    # Map sorting parameter
    if params[:sort_by].present?
      attribute = sort_map[params[:sort_by]]
      if attribute
        direction = params[:sort_direction]&.downcase == 'desc' ? 'desc' : 'asc'
        ransack_params['s'] = "#{attribute} #{direction}"
      end
    end

    ransack_params
  end
end
