class TipoEntrega < ApplicationRecord
  self.table_name = 'TipoEntrega'

  has_many :pedidos, class_name: 'Pedido', foreign_key: 'tipoEntregaId', dependent: :restrict_with_error
end
