class GrupoAcompanhamento < ApplicationRecord
  self.table_name = 'GrupoAcompanhamento'

  has_many :item_acompanhamentos, class_name: 'ItemAcompanhamento', foreign_key: 'grupoAcompanhamentoId',
                                  dependent: :restrict_with_error, inverse_of: :grupo_acompanhamento
end
