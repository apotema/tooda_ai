class PedidoItemAcompanhamento < ApplicationRecord
  self.table_name = 'PedidoItemAcompanhamento'

  belongs_to :pedido_item, class_name: 'PedidoItem', foreign_key: 'pedidoItemid',
                           inverse_of: :pedido_item_acompanhamentos
  belongs_to :item_acompanhamento, class_name: 'ItemAcompanhamento', foreign_key: 'itemAcompanhamentoid',
                                   inverse_of: :pedido_item_acompanhamentos

  validates :quantidade, presence: true, numericality: { greater_than: 0 }
  validates :valor, presence: true, numericality: { greater_than_or_equal_to: 0 }
end
