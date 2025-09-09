class Pedido < ApplicationRecord
  self.table_name = 'Pedido'
  
  # Associations
  belongs_to :conta, class_name: 'Conta', foreign_key: 'contaid'
  belongs_to :status_pedido, class_name: 'StatusPedido', foreign_key: 'statuspedidoid'
  belongs_to :tipo_entrega, class_name: 'TipoEntrega', foreign_key: 'tipoEntregaId'
  belongs_to :operador, class_name: 'Operador', foreign_key: 'operadorId', optional: true
  
  has_many :pedido_items, class_name: 'PedidoItem', foreign_key: 'pedidoid', dependent: :destroy
  
  # Validations
  validates :data, presence: true
  validates :conta, presence: true
  validates :status_pedido, presence: true
end