class ItemAcompanhamento < ApplicationRecord
  self.table_name = 'ItemAcompanhamento'

  belongs_to :grupo_acompanhamento, class_name: 'GrupoAcompanhamento', foreign_key: 'grupoAcompanhamentoId'
  has_many :pedido_item_acompanhamentos, class_name: 'PedidoItemAcompanhamento', foreign_key: 'itemAcompanhamentoid',
                                         dependent: :restrict_with_error
end
