class PedidoItem < ApplicationRecord
  self.table_name = 'PedidoItem'
  
  belongs_to :pedido, class_name: 'Pedido', foreign_key: 'pedidoid'
  belongs_to :item, class_name: 'Item', foreign_key: 'itemid'
  belongs_to :status_pedido_item, class_name: 'StatusPedidoItem', foreign_key: 'StatusPedidoItemId'
  
  validates :quantidade, presence: true, numericality: { greater_than: 0 }
  validates :valor, presence: true, numericality: { greater_than_or_equal_to: 0 }
end