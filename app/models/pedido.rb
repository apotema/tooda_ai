class Pedido < ApplicationRecord
  self.table_name = 'Pedido'

  # Associations
  belongs_to :conta, class_name: 'Conta', foreign_key: 'contaid', inverse_of: :pedidos
  belongs_to :status_pedido, class_name: 'StatusPedido', foreign_key: 'statuspedidoid', inverse_of: :pedidos
  belongs_to :tipo_entrega, class_name: 'TipoEntrega', foreign_key: 'tipoEntregaId', inverse_of: :pedidos
  belongs_to :operador, class_name: 'Operador', foreign_key: 'operadorId', optional: true, inverse_of: :pedidos

  has_many :pedido_items, class_name: 'PedidoItem', foreign_key: 'pedidoid', dependent: :destroy, inverse_of: :pedido

  # Validations
  validates :data, presence: true
end
