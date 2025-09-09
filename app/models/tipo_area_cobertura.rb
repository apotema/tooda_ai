class TipoAreaCobertura < ApplicationRecord
  self.table_name = 'TipoAreaCobertura'

  has_many :barracas, class_name: 'Barraca', foreign_key: 'TipoAreaCoberturaId', dependent: :restrict_with_error,
                      inverse_of: :tipo_area_cobertura
end
