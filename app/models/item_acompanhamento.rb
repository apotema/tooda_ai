class ItemAcompanhamento < ApplicationRecord
  self.table_name = 'ItemAcompanhamento'

  belongs_to :grupo_acompanhamento, class_name: 'GrupoAcompanhamento', foreign_key: 'grupoAcompanhamentoId',
                                    inverse_of: :item_acompanhamentos
  has_many :pedido_item_acompanhamentos, class_name: 'PedidoItemAcompanhamento', foreign_key: 'itemAcompanhamentoid',
                                         dependent: :restrict_with_error, inverse_of: :item_acompanhamento
end
