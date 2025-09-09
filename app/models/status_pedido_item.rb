class StatusPedidoItem < ApplicationRecord
  self.table_name = 'StatusPedidoItem'
  
  has_many :pedido_items, class_name: 'PedidoItem', foreign_key: 'StatusPedidoItemId', dependent: :restrict_with_error
end