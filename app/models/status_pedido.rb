class StatusPedido < ApplicationRecord
  self.table_name = 'StatusPedido'

  has_many :pedidos, class_name: 'Pedido', foreign_key: 'statuspedidoid', dependent: :restrict_with_error
end
